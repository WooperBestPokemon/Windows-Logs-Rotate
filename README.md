Windows Log Rotate
==================

## How to use

Simply add the desired log into the config.csv file.
<ul>
<li>**The first part** is where the log folder file is. ->
ex : C:\Apache2\logs

<li>**The second part** is how many logs you want to keep in your rotation. ->
ex: 30

<li>**The third part** is the name of the file. ->
ex : access.log
</ul>

So the result should looks like this -> C:/Script/BigBrother/logs;5;debug.log

Note : it's important that you separate those part with a **';'**.

All you need to do now is to schedule it in the task scheduler.