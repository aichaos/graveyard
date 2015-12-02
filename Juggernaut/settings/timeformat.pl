# Time Format
#
# This variable will specify how the timestamps (particularly in log files)
# will be formatted.
#
# You can compose this with either of the tags below in any combination
# you want:
#
# <day_name>          - The day name (i.e. "Monday" or "Thursday")
# <day_abbrev>        - Abbreviation of the day (i.e. "Mon" or "Thur")
# <day_month>         - The day of the month (1-31)
# <day_year>          - The day of the year (1-365)
# <month_name>        - The month name (i.e. "January" or "March")
# <month_abbrev>      - Month abbreviation (i.e. "Jan" or "Mar")
# <year_full>         - The full year (i.e. 2004)
# <year_short>        - The short year (i.e.  04)
# <hour_12>           - 12 hour format (1-12)
# <hour_24>           - 24 hour format (0-23)
# <min>               - Minutes (0-59)
# <secs>              - Seconds (0-59)
# <ext>               - The AM/PM extension.
#
# Examples:
#	<day_name>, <month_name> <day_month> <year_full> @ <hour_12>:<min>:<secs> <ext>
#		"Monday, January 1 2004 @ 4:32:05 PM"
#	<day_abbrev> <month_abbrev> <day_month> <hour_24>:<min>:<secs> <year_full>
#		"Mon Jan 1 2004 16:32:05 2004"
#
# Set how you want to format your timestamps below:

$chaos->{_system}->{config}->{timestamp} = '<day_name>, <month_name> <day_month> <year_full> @ <hour_12>:<min>:<secs> <ext>';

# Return true.
1;