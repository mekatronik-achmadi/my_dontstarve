### Backup saves
~~~
adb shell pm list package | grep -i starve
adb backup -apk -f saves_daynumber.ab com.kleientertainment.doNotStarveShipwrecked
( printf "\x1f\x8b\x08\x00\x00\x00\x00\x00" ; tail -c +25 saves_daynumber.ab ) |  tar xfvz -
~~~

### Restore saves
~~~
adb shell pm list package | grep -i starve
adb restore saves_daynumber.ab
~~~
