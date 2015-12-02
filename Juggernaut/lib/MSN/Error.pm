#================================================
package MSN::Error;
#================================================


sub converterror
{
	my $err = shift;
	my %errlist;

	$errlist{200} = 'Invalid Syntax';
	$errlist{201} = 'Invalid parameter';
	$errlist{205} = 'Invalid user';
	$errlist{206} = 'Domain name missing';
	$errlist{207} = 'Already logged in';
	$errlist{208} = 'Invalid User Name';
	$errlist{209} = 'Invlaid Friendly Name';
	$errlist{210} = 'List Full';
	$errlist{215} = 'User already on list';
	$errlist{216} = 'User not on list';
	$errlist{217} = 'User not online';						 #<--
	$errlist{218} = 'Already in that mode';
	$errlist{219} = 'User is in the opposite list';
	$errlist{223} = 'Too Many Groups';						 #<--
	$errlist{224} = 'Invalid Groups ';						 #<--
	$errlist{225} = 'User Not In Group';					 #<--
	$errlist{229} = 'Group Name too long';					 #<--
	$errlist{230} = 'Cannont Remove Group Zero';			 #<--
	$errlist{231} = 'Invalid Group';							 #<--
	$errlist{280} = 'Switchboard Failed';					 #<--
	$errlist{281} = 'Transfer to Switchboard failed';	 #<--

	$errlist{300} = 'Required Field Missing';
	$errlist{301} = 'Too Many Hits to FND';				 #<--
	$errlist{302} = 'Not Logged In';

	$errlist{500} = 'Internal Server Error';
	$errlist{501} = 'Database Server Error';
	$errlist{502} = 'Command Disabled';
	$errlist{510} = 'File Operation Failed';
	$errlist{520} = 'Memory Allocation Failed';
	$errlist{540} = 'Challenge Responce Failed';

	$errlist{600} = 'Server Is Busy';
	$errlist{601} = 'Server Is Unavailable';
	$errlist{602} = 'Peer Name Server is Down';
	$errlist{603} = 'Database Connection Failed';
	$errlist{604} = 'Server Going Down';
	$errlist{605} = 'Server Unavailable';

	$errlist{707} = 'Could Not Create Connection';
	$errlist{710} = 'Bad CVR Parameter Sent';
	$errlist{711} = 'Write is Blocking';
	$errlist{712} = 'Session is Overloaded';
	$errlist{713} = 'Too Many Active Users';
	$errlist{714} = 'Too Many Sessions';
	$errlist{715} = 'Command Not Expected';
	$errlist{717} = 'Bad Friend File';
	$errlist{731} = 'Badly Formated CVR';

	$errlist{800} = 'Friendly Name Change too Rapidly';

	$errlist{910} = 'Server Too Busy';
	$errlist{911} = 'Authentication Failed';
	$errlist{912} = 'Server Too Busy';
	$errlist{913} = 'Not allowed While Offline';
	$errlist{914} = 'Server Not Available';
	$errlist{915} = 'Server Not Available';
	$errlist{916} = 'Server Not Available';
	$errlist{917} = 'Authentication Failed';
	$errlist{918} = 'Server Too Busy';
	$errlist{919} = 'Server Too Busy';
	$errlist{920} = 'Not Accepting New Users';
	$errlist{921} = 'Server Too Busy: User Digest';
	$errlist{922} = 'Server Too Busy';
	$errlist{923} = 'Kids Passport Without Parental Consent';	#<--K
	$errlist{924} = 'Passport Account Not Verified';

	return ( $errlist{$err} || 'unknown error' );
}


1;
