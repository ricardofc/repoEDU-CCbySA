# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2017-05-05 00:22:24.000000000 +0200

#!/bin/bash

tinicio=$1
tlimite=$2
FATHERPID=$3
while [ $tlimite -gt $((`date +%s`-$tinicio)) ]
do

 tput sc 

 DATA=$(date -u --date @$(($tlimite - $((`date +%s`-$tinicio)))) +%M:%S)
 COLUMNS=$((`tput cols` - 5))
 tput cup 0 $COLUMNS

 COLOR_CHANGE=$(tput smso)
 COLOR_ORIGINAL=$(tput rmso)
 echo -n ${COLOR_CHANGE}$DATA${COLOR_ORIGINAL}

 tput rc

 sleep 1
done
tput sc
tput cup 0 $COLUMNS
echo -n "${COLOR_ORIGINAL}     ${COLOR_ORIGINAL}"
tput rc
kill $FATHERPID 1>/dev/null 2>&1 
echo -e "\nRematouse o tempo!!!--------------------------------------"
