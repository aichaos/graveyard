#      .   .               <Leviathan>
#     .:...::     Command Name // !getfile
#    .::   ::.     Description // E-Mail a file as an attachment.
# ..:;;. ' .;;:..        Usage // !getfile <to> <filepath>
#    .  '''  .     Permissions // Master Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2005 AiChaos Inc.

sub getfile {
	my ($self,$client,$msg) = @_;

	# This command is Master Only.
	return "This command is Master Only!" unless &isMaster($client);

	# See if a filename was given.
	if (length $msg > 0) {
		# Data from the message.
		my ($to,$mess) = split(/ /, $msg, 2);
		$msg = $mess;

		# Validate the e-mail.
		if ($to =~ /\@/ && $to =~ /\./) {
			# Ok.
		}
		else {
			return "Invalid e-mail address!";
		}

		# See if the file exists.
		if (!-e $msg) {
			return "That file could not be found!";
		}

		# Get the file extension.
		my @parts = split(/\./, $msg);
		my $ext = $parts [ (scalar(@parts) - 1) ];

		print "Ext: $ext\n";

		############################
		# Find the content-type... #
		############################

		my %mtypes = (
			'doc' => 'application/msword',
			'bin' => 'application/octet-stream',
			'exe' => 'application/octet-stream',
			'pdf' => 'application/pdf',
			'gtar' => 'application/x-gtar',
			'gz'  => 'application/x-gzip',
			'class' => 'application/x-java-vm',
			'jar' => 'application/x-java-archive',
			'tar' => 'application/x-tar',
			'zip' => 'application/zip',

			'ua'  => 'audio/basic',
			'wav' => 'audio/x-wav',
			'mid' => 'audio/x-midi',
			'midi' => 'audio/x-midi',

			'bmp' => 'image/bmp',
			'gif' => 'image/gif',
			'jpg' => 'image/jpeg',
			'jpe' => 'image/jpeg',
			'jpeg' => 'image/jpeg',
			'tif' => 'image/tiff',
			'tiff' => 'image/tiff',
			'xbm' => 'image/x-xbitmap',

			'htm' => 'text/html',
			'html' => 'text/html',
			'txt' => 'text/plain',
			'rtf' => 'text/richtext',

			'mpg' => 'video/mpeg',
			'mpe' => 'video/mpeg',
			'mpeg' => 'video/mpeg',
			'qt'  => 'video/quicktime',
			'mov' => 'video/quicktime',
			'avi' => 'video/x-msvideo',
		);

		my $file_type;

		if (exists $mtypes{$ext}) {
			$file_type = $mtypes{$ext};
		}
		else {
			$file_type = 'text/plain';
		}

		# Prepare to send the e-mail.
		use MIME::Lite;

		# E-Mail data.
		my $from = $chaos->{config}->{email}->{from} || 'AiChaos Leviathan <leviathan@aichaos.com>';
		my $subject = 'Leviathan Requested File Attachment';
		my $message_body = "The requested file $msg is attached to this e-mail.";

		# Create the MIME Msg.
		my $mime_msg = MIME::Lite->new (
			From    => $from,
			To      => $to,
			Subject => $subject,
			Type    => 'multipart/mixed',
		) or return "Could not create MIME body: $!";

		# Attach the text part (e-mail message)
		$mime_msg->attach (
			Type => 'TEXT',
			Data => $message_body,
		) or return "Could not attach e-mail message: $!";

		# Attach the file.
		my $filename = $msg;
		my $filerec = (($parts [ (scalar(@parts) - 2) ]) . '.' . ($parts [ (scalar(@parts) - 1) ]));

		print "Debug // Filename: $filename\n\tFileRec: $filerec\n\n";
		$mime_msg->attach (
			Type => $file_type,
			Path => $filename,
			Disposition => 'attachment',
		) or return "Could not attach $filerec: $!";

		# Connect to SMTP.
		my $smtp = $chaos->{config}->{email}->{smtp} || 'localhost';
		my $start = time();

		# Send the message.
		MIME::Lite->send ('smtp', $smtp, Timeout => 60);
		$mime_msg->send ();

		my $end = time();
		my $elapse = $end - $start;

		return "Transaction complete.\n\n"
			. "The file $filerec has been e-mailed to $to in $elapse seconds.";
	}
	else {
		return "You must provide a file path to be sent!\n\n"
			. "!getfile ./data/alerts.txt\n"
			. "!getfile C:/AUTOEXEC.BAT";
	}
}
{
	Restrict => 'Botmaster',
	Category => 'Botmaster Commands',
	Description => 'E-Mail a file as an attachment.',
	Usage => '!getfile <to> <filepath>',
	Listener => 'All',
};