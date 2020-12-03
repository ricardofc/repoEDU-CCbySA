# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2017-05-06 00:05:20.000000000 +0200

#!/bin/bash

#Atrapar sinais:

clear

## Ignorar <Ctrl>+<c>: SIGGINT (2) 
trap '' 2

function f_trap(){
echo '-------------------------------'
echo 'Ignorando <Ctrl>+<c>. Inténteo!'
echo '-------------------------------'
for i in $(seq 1 15) 
do 
  echo $i
  sleep 1
done 
}

f_trap
