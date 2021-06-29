Windows Log Rotate
==================

## How to use

Simply add the desired log into the config.csv file.

The first part is where the log folder file is
ex : C:\Apache2\logs

The second part is how many logs you want to keep in your rotation.
ex: 30

The third part is the name of the file. 
ex : access.log

Note : it's important that you separate those part with a '~'.

All you need to do now is to schedule it in the task scheduler.