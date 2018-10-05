# harbour-LiveTrack
LiveTrack is an Sailfish application for continuous logging of location coordinates, designed to record hiking, biking tracks and other outdoor activities. Track points are uploaded at chosen intervals to dedicated server in real time. This client works with Nextcloud Phonetrack Extension , Traccar, and everything that supports the Osmand Get Api . Together they make a complete self owned and controlled client–server solution.

Features:

simple and small ;
low memory and battery impact;
uses GPS based location data;
synchronizes location with web server in real time, in case of problems keeps retrying (to send);
configurable tracking settings such as send interval.

Howto:
Set up Backend, get Logging URL, and enter it to Serverurl in Settings.
For Phonetrack Application you can enter self choosen ID in Textfield below.
Example:
Phonetrack gives you following URL und HTTP Get Logger:
https://x.x/apps/phonetrack/logGet/g9c43b634e67dc70bdaa50e345b1492c/yourname?lat=LAT&lon=LON&alt=ALT&acc=ACC&bat=BAT&sat=SAT&speed=SPD&bearing=DIR&timestamp=TIME

Cut it to:
https://x.x/apps/phonetrack/logGet/g9c43b634e67dc70bdaa50e345b1492c/

and enter this to ServerURL
then enter whatever ID you want under ID texfield,
go back and click play to start logging.
After you're done with tracking you may have some points in "to send".
You can flush them by pressing the X Button as long as they get 0.

It's my first app, so don't be that mad, because it's so bad :D
I hope it's somewhat useful for you, i did it for tracking bike routes and roadtrips and it works quite nice now, so I'll just drop it here :)

Sourcecode is on Github, feel free to help :)

Icon made by Greg Goncharov (@gregguh)

