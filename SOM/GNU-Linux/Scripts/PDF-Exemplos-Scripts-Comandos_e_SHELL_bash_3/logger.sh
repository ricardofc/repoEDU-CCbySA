# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2016-02-06 10:05:44.000000000 +0100

#!/bin/bash

#Atrapar sinais:

## <Ctrl>+<c>: SIGGINT (2)
trap 'clear;echo -e "\n<Ctrl>+<c>";id;logger -p emerg "Ctrl>+<c> executado";sleep 2' 2

for i in $(seq 1 15)
do 
  echo $i
  sleep 1
done 
