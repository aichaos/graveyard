# $Id: mshttps.pm,v 0.10 2003/04/09 typo_pl@hotmail.com	 Exp $
#
# Copyright 2003 Johnny Lee (typo_pl@hotmail.com)
#
# This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.
#
# Description:
# --------------------------------------------------------------------------------
# Add SSL support for Windows under LWP.
#
# Use the builtin Windows SSL libraries.
#
# Use WinHttp COM object (on Win2K-SP3, WinXP-SP1, and WinXP Server 2003)
# if WinHttp not found, fallback to Wininet (from Win32::Internet)
#
# Set PERL_LWP_MSHTTPS_USE_WININET env. variable to a non-empty value
#   to force Wininet to be used
#
# Set PERL_LWP_MSHTTPS_DONT_IGNORE_SSL_ERRORS env. variable to a non-empty value.
#   to NOT ignore SSL certificate errors
#
# WinHttp info:
# About: http://msdn.microsoft.com/library/en-us/winhttp/http/about_winhttp.asp
# Docs: http://msdn.microsoft.com/library/en-us/winhttp/http/winhttprequest.asp
#
# Win32::Internet docs:
# http://aspn.activestate.com/ASPN/Reference/Products/ActivePerl/site/lib/Win32/Internet.html
#
# Caveats with using Wininet for HTTPS
# (Article by Jon Udell from Byte mag cached by Google):
#
# http://216.239.53.100/search?q=cache:oDiSzS1N-mQC:www.byte.com/art/9802/sec7/art1.htm
#
# History:
# --------------------------------------------------------------------------------
# 2003 Apr 09	Created. Used WinHttp COM object via Win32::OLE
# 2003 Apr 10	Added code to fallback to Wininet via Win32::Internet
# 2003 Apr 14	Check registry to see which WinHttp DLLs are installed
#

package LWP::Protocol::mshttps;

use strict;

require LWP::Debug;
require HTTP::Response;
require HTTP::Status;
require Win32::OLE;

use vars qw(@ISA);

require LWP::Protocol;
@ISA = qw(LWP::Protocol);

################################################################################

my $use_lib = 3; # bitflags: 1 for WinHttp, 2 for Wininet, 3 for both

################################################################################

sub _fixup_header
{
	my($self, $h, $url, $proxy) = @_;

	# Extract 'Host' header
	my $hhost = $url->authority;
	$hhost =~ s/^([^\@]*)\@//;	# get rid of potential "user:pass@"
	$h->init_header('Host' => $hhost);

	# add authorization header if we need them.	 HTTP URLs do
	# not really support specification of user and password, but
	# we allow it.
	if (defined($1) && not $h->header('Authorization')) {
		require URI::Escape;
		$h->authorization_basic(map URI::Escape::uri_unescape($_),
								split(":", $1, 2));
	}

	if ($proxy) {
		# Check the proxy URI's userinfo() for proxy credentials
		# export http_proxy="http://proxyuser:proxypass@proxyhost:port"
		my $p_auth = $proxy->userinfo();
		if(defined $p_auth) {
			require URI::Escape;
			$h->proxy_authorization_basic(map URI::Escape::uri_unescape($_),
						  split(":", $p_auth, 2))
		}
	}
}

# ProgIDs for WinHttp 5.0 and 5.1 as of Apr 9 2003
my $winhttp50 = "WinHttp.WinHttpRequest.5";
my $winhttp51 = "WinHttp.WinHttpRequest.5.1";

sub _get_progids()
{
	use Win32::TieRegistry(Delimiter => "/");

	my @winhttp_progids = ($winhttp50, $winhttp51);
	my @available_progids = ();

	foreach (@winhttp_progids)
	{
		my $clsid = $Registry->{"HKEY_CLASSES_ROOT/$_/CLSID/"};
		push(@available_progids, $_) if (defined($clsid));
	}

	return @available_progids;
}

sub _get_winhttp_object_via_OLE($@)
{
	my ($get, @ids) = @_;

	my $obj;

	foreach (@ids)
	{
		$obj = Win32::OLE->$get($_);
		last if (defined($obj));
	}

	return $obj;
}

sub _get_winhttp_object()
{
	my $obj;
	my $use_winhttp = !!($use_lib & 1);
	my $use_wininet = !!($use_lib & 2);
	my $using_wininet = 0;

	if ($ENV{PERL_LWP_MSHTTPS_USE_WININET})
	{
		$use_winhttp = 0;
		$use_wininet = 1;
	}

	if ($use_winhttp)
	{
		my @ids = _get_progids();

		$obj = _get_winhttp_object_via_OLE('GetActiveObject', @ids);
		unless (defined $obj)
		{
			$obj = _get_winhttp_object_via_OLE('new', @ids);
		}
	}

	unless (defined $obj)
	{
		if ($use_wininet)
		{
			# fall back to Wininet, provided by Win32::Internet
			$obj = LWP::Protocol::mswininet->new();
			$using_wininet = 1 if ($obj);
		}
	}

	return ($obj, $using_wininet);
}

sub hlist_remove {
	my($hlist, $k) = @_;
	$k = lc $k;
	for (my $i = @$hlist - 2; $i >= 0; $i -= 2) {
		next unless lc($hlist->[$i]) eq $k;
		splice(@$hlist, $i, 2);
	}
}

sub _get_error($$$)
{
	my ($obj, $send, $using_wininet) = @_;
	my $code;
	my $mess;
	my $err;
	my $err_num;

	if ($using_wininet)
	{
		$err_num = $obj->ErrorNumber();
		if ($err_num)
		{
			$err = $obj->Error();
		}
	}
	else
	{
		$err = Win32::OLE->LastError();
		$err = "" unless ($err);
		$err_num = int(Win32::OLE->LastError()) & 0xFFFF;
	}

	if (0 == $err_num)
	{
		if ($send)
		{
			$code = $obj->Status();
			$mess = $obj->StatusText();
		}

		unless ($code && $mess)
		{
			$code = 200;
			$mess = "OK";
		}
	}
	else
	{
		$code = 500;
		if ($err =~ /OLE exception.*\x0a(.*)\x0a\x0a\x0aWin32/si)
		{
			$mess = $1;
			if ($mess =~ /\s+$/)
			{
				$mess = $`;
			}
		}
		else
		{
			$mess = $err;
			
		}
		$mess .= " [$err_num]";
	}

	return ($code, $mess);
}

sub _ignore_cert_errors($$)
{
	my ($obj, $using_wininet) = @_;

	if ($using_wininet)
	{
		$obj->IgnoreCertificateErrors();
	}
	else
	{
		my $WinHttpRequestOption_SslErrorIgnoreFlags = 4;
		my $val;

		$val = $obj->Option($WinHttpRequestOption_SslErrorIgnoreFlags);

		# See WinHttpRequestOption_SslErrorIgnoreFlags docs
		# for the meaning of this value 0x3300
		$val |= 0x3300; 

		$obj->SetProperty("Option", $WinHttpRequestOption_SslErrorIgnoreFlags, $val);
	}
}

sub request
{
	my($self, $request, $proxy, $arg, $size, $timeout) = @_;
	LWP::Debug::trace('()');

	# check method
	my $method = $request->method;
	unless ($method =~ /^[A-Za-z0-9_!\#\$%&\'*+\-.^\`|~]+$/) {	# HTTP token
		return new HTTP::Response &HTTP::Status::RC_BAD_REQUEST,
					  'Library does not allow method ' .
					  "$method for 'https:' URLs";
	}

	if ($method eq "CONNECT") {
		return new HTTP::Response &HTTP::Status::RC_BAD_REQUEST,
					  'Library does not allow method ' .
					  "$method for 'https:' URLs";
	}

	my $url = $request->url;
	my $winhttp_obj;
	my $using_wininet;
	
	($winhttp_obj, $using_wininet) = _get_winhttp_object();

	return new HTTP::Response &HTTP::Status::RC_BAD_REQUEST,
				  'Cannot create Winhttp object' unless (defined($winhttp_obj));

	my $warn = Win32::OLE->Option('Warn');
	Win32::OLE->Option(Warn => 0);

	# Check if we're proxy'ing

	if (defined($proxy))
	{
		# $proxy is an URL to an HTTP server which will proxy this request
		my $HTTPREQUEST_PROXYSETTING_PROXY = 2;
		$winhttp_obj->SetProxy($HTTPREQUEST_PROXYSETTING_PROXY, $proxy->host.':'.$proxy->port);
	}

	my @h;
	my $request_headers = $request->headers->clone;
	$self->_fixup_header($request_headers, $url, $proxy);

	$request_headers->scan(sub {
				   my($k, $v) = @_;
				   $v =~ s/\n/ /g;
				   push(@h, $k, $v);
			   });

	# Check that content and content-length are kosher

	my $content_ref = $request->content_ref;
	$content_ref = $$content_ref if ref($$content_ref);
	my $has_content;

	if (ref($content_ref) eq 'CODE')
	{
		Win32::OLE->Option('Warn' => $warn);
		undef $winhttp_obj;
		return new HTTP::Response &HTTP::Status::RC_BAD_REQUEST,
					'Library does not allow CODE references for content';
	} else {
		# Set (or override) Content-Length header
		my $clen = $request_headers->header('Content-Length');
		if (defined($$content_ref) && length($$content_ref)) {
			$has_content++;
			if (!defined($clen) || $clen ne length($$content_ref)) {
				if (defined $clen) {
					warn "Content-Length header value was wrong, fixed";
					hlist_remove(\@h, 'Content-Length');
				}
				push(@h, 'Content-Length' => length($$content_ref));
			}
		}
		elsif ($clen) {
			warn "Content-Length set when there is not content, fixed";
			hlist_remove(\@h, 'Content-Length');
		}
	}

	# Open connection/request

	$winhttp_obj->Open($method, $url);

	my ($code, $mess);

	($code, $mess) = _get_error($winhttp_obj, 0, $using_wininet);

	if (200 == $code)
	{
		# Grab headers and put in Request object

		while (@h)
		{
			my($k, $v) = splice(@h, 0, 2);

			$winhttp_obj->SetRequestHeader($k, $v);
		}

		# Ignore SSL Certicate errors unless user disallows

		if (!$ENV{PERL_LWP_MSHTTPS_DONT_IGNORE_SSL_ERRORS})
		{
			_ignore_cert_errors($winhttp_obj, $using_wininet);
		}

		# Send request

		if ($has_content) {
			$winhttp_obj->Send($content_ref);
		} else {
			$winhttp_obj->Send();
		}

		# Check for errors

		($code, $mess) = _get_error($winhttp_obj, 1, $using_wininet);
	}

	my $response = HTTP::Response->new($code, $mess);

	# Grab all the response headers and
	# put them into the response object

	my $headers = $winhttp_obj->GetAllResponseHeaders();
	@h = split("\r\n", $headers);

	foreach (@h)
	{
		my ($key, $val);
		($key, $val) = split(': ', $_, 2);
		if ($key && $val)
		{
			$response->push_header($key, $val);
		}
	}

	$response->request($request);

	if (my @te = $response->remove_header('Transfer-Encoding')) {
		$response->push_header('Client-Transfer-Encoding', \@te);
	}

	my $body = $winhttp_obj->ResponseText();

	Win32::OLE->Option('Warn' => $warn);
	undef $winhttp_obj;

	$response = $self->collect($arg, $response, sub {
														my $buf = "";
														$buf = $body;
														$body = "";
														return \$buf;
													});

	# no LWP keep-alive support

	$response;
}


#-----------------------------------------------------------

# Use Win32::Internet's Wininet functions to mimic WinHttp semantics
#
# This package provides the same methods as the WinHttp COM object
# that the mshttps package uses for sending requests, setting proxy info, etc.
# This allows the mshttps code to use one set of code for WinHttp and Wininet
#
# These are the WinHttp methods mimicked in this package:
# SetProxy Open SetRequestHeader Send GetAllResponseHeaders ResponseText Status StatusText
#

package LWP::Protocol::mswininet;

use strict;

require Win32::Internet;

my $HTTP_QUERY_RAW_HEADERS_CRLF = 22;
my $HTTP_QUERY_STATUS_CODE = 19;
my $HTTP_QUERY_STATUS_TEXT = 20;
my $INTERNET_OPEN_TYPE_PROXY = 3;
my $INTERNET_FLAG_SECURE = 0x00800000;

sub new
{
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self  = {
		PROXY	=> undef,
		INET	=> undef,
		HTTP	=> undef,
		REQ		=> undef,
		ERROR	=> 0,
		ERROR_NUMBER   => 0,
		DEBUG	=> undef,
	};

	# Turn on debug output?
	if ($ENV{PERL_LWP_MSHTTPS_DEBUG})
	{
		$self->{DEBUG} = $ENV{PERL_LWP_MSHTTPS_DEBUG};
	}

	bless ($self, $class);
	return $self;
}

sub Error($)
{
	my $self = shift;
	print STDERR "Error called $self->{ERROR}\n" if ($self->{DEBUG});
	return $self->{ERROR};
}

sub ErrorNumber($)
{
	my $self = shift;
	print STDERR "ErrorNumber called $self->{ERROR_NUMBER}\n" if ($self->{DEBUG});
	return $self->{ERROR_NUMBER};
}

sub SetError($$$)
{
	my ($self, $num, $string) = @_;

	$self->{ERROR_NUMBER} = $num;
	$string = "No Win32::Internet::HTTP::Request object." unless (defined($string));
	$self->{ERROR} = $string;
	print STDERR "SetError called '$num' '$string'\n" if ($self->{DEBUG});
}

sub CheckForError($)
{
	my $self = shift;
	my $num;
	my $str;

	# If there's a Win32::Internet error...
	if ($self->{INET} && $self->{INET}->Error())
	{
		# grab the error number and string
		($num, $str) = $self->{INET}->Error();
		if (0 != $num)
		{
			# store it in our object for future ref
			$self->SetError($num, $str);
			print STDERR "CheckForError called '$num' '$str'\n" if ($self->{DEBUG});
		}
	}

	# No error, clear out any previous error
	unless ($num)
	{
		$self->SetError(0, "");
		print STDERR "CheckForError called cleared\n" if ($self->{DEBUG});
	}
}

sub IgnoreCertificateErrors($)
{
	my $self = shift;

	if ($self->{REQ})
	{
		my $val;
		my $INTERNET_OPTION_SECURITY_FLAGS = 31;

		$val = $self->{REQ}->QueryOption($INTERNET_OPTION_SECURITY_FLAGS);

		# INTERNET_FLAG_IGNORE_CERT_DATE_INVALID	0x00002000
		# INTERNET_FLAG_IGNORE_CERT_CN_INVALID		0x00001000
		# SECURITY_FLAG_IGNORE_UNKNOWN_CA			0x00000100
		# SECURITY_FLAG_IGNORE_WRONG_USAGE			0x00000200
		$val = 0 if (!defined($val) || 0 == length($val));
		$val |= 0x00003300;

		$self->{REQ}->SetOption($INTERNET_OPTION_SECURITY_FLAGS, $val);
	}
}

sub SetProxy($$$)
{
	my ($self, $flags, $proxy) = @_;

	# save the proxy info for the Open call
	$self->{PROXY} = $proxy;

	print STDERR "SetProxy called '$flags' '$proxy'\n" if ($self->{DEBUG});
}

sub Open($$$)
{
	my ($self, $method, $url) = @_;
	my $result;
	my %hash = ();

	# First create an Internet object, sending proxy info, if any

	if (defined($self->{PROXY}))
	{
		$hash{"proxy"} = $self->{PROXY};
		$hash{"opentype"} = $INTERNET_OPEN_TYPE_PROXY;
	}
	$self->{INET} = new Win32::Internet(\%hash);
	$result = $self->{INET};

	# Next, create an HTTP object

	if ($result)
	{
		%hash = ();
		$hash{"server"} = $url->authority;
		$hash{"port"} = ($url->port) ? $url->port : 443;
		
		$result = $self->{INET}->HTTP($self->{HTTP}, \%hash);
		$self->CheckForError();
	}
	else
	{
		$self->SetError(100, "Can't create Win32::Internet object.");
	}

	# Finally, open a Request object

	if ($result)
	{
		my $fullpath = $url->path_query;
		$fullpath = "/" unless length $fullpath;

		%hash = ();
		$hash{"path"} = $fullpath;
		$hash{"method"} = $method;
		$hash{"flags"} = $INTERNET_FLAG_SECURE;

		$result = $self->{HTTP}->OpenRequest($self->{REQ}, \%hash);
		$self->CheckForError();
	}

	print STDERR "Open called '$method' '$url'\n" if ($self->{DEBUG});
}

sub SetRequestHeader($$$)
{
	my ($self, $key, $val) = @_;

	if ($self->{REQ})
	{
		$self->{REQ}->AddHeader("$key: $val");
		$self->CheckForError();
	}
	else
	{
		$self->SetError(200);
	}
	print STDERR "SetRequestHeader called '$key' '$val'\n" if ($self->{DEBUG});
}

sub Send($$)
{
	my ($self, $content) = @_;
	
	if ($self->{REQ})
	{
		$self->{REQ}->SendRequest($content);
		$self->CheckForError();
	}
	else
	{
		$self->SetError(300);
	}

	if ($self->{DEBUG})
	{
		$content = "" if (!defined($content));
		if (length($content))
		{
			$content = "'" . $content . "'";
		}
		print STDERR "Send called $content\n";
	}
}

sub GetAllResponseHeaders($)
{
	my $self = shift;
	my $headers;

	if ($self->{REQ})
	{
		$headers = $self->{REQ}->QueryInfo("", $HTTP_QUERY_RAW_HEADERS_CRLF);
		$self->CheckForError();
	}
	else
	{
		$self->SetError(400);
	}
	print STDERR "GetAllResponseHeaders called '$headers'\n" if ($self->{DEBUG});
	return $headers;
}

sub ResponseText($)
{
	my $self = shift;
	my $text;

	if ($self->{REQ})
	{
		$text = $self->{REQ}->ReadEntireFile();
		$self->CheckForError();
	}
	else
	{
		$self->SetError(500);
	}
	print STDERR "ResponseText called\n" if ($self->{DEBUG});
	return $text;
}

sub Status($)
{
	my $self = shift;
	my $code;

	if ($self->{REQ})
	{
		$code = $self->{REQ}->QueryInfo("", $HTTP_QUERY_STATUS_CODE);
		$self->CheckForError();
	}
	else
	{
		$self->SetError(600);
	}
	print STDERR "Status called '$code'\n" if ($self->{DEBUG});

	return $code;
}

sub StatusText($)
{
	my $self = shift;
	my $text;

	if ($self->{REQ})
	{
		$text = $self->{REQ}->QueryInfo("", $HTTP_QUERY_STATUS_TEXT);
		$self->CheckForError();
	}
	else
	{
		$self->SetError(700);
	}
	print STDERR "StatusText called '$text'\n" if ($self->{DEBUG});
	return $text;
}


1;
