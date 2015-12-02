@echo off
echo GUI Debugging: use this file if for some reason the GUI file fails to open
echo (probably due to error). Closing this file will close the GUI (if it works),
echo but keeping this window open will enable you to see what the error message(s)
echo are. Anything outputted by the GUI will be printed below:
echo.
perl GUI.pl
echo.
echo The output of the file was printed above. If it's an error, view it and then
pause