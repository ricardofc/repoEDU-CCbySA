# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2016-01-22 00:56:56.000000000 +0100

#!/bin/bash

#Atrapar sinais:

clear

## Ignorar <Ctrl>+<c>: SIGGINT (2)
trap '' 2

echo '-------------------------------'
echo 'Ignorando <Ctrl>+<c>. Inténteo!'
echo '-------------------------------'
for i in $(seq 1 15)
do 
  echo $i
  sleep 1
done 


## Resetear valor por defecto <Ctrl>+<c>: SIGGINT (2)
trap - 2

echo '----------------------------------------'
echo 'Devolvendo valor a <Ctrl>+<c>. Inténteo!'
echo '----------------------------------------'
for i in $(seq 1 15)
do 
  echo $i
  sleep 1
done 
