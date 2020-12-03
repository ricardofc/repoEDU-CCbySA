# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2017-05-04 18:58:18.000000000 +0200

#!/bin/bash

declare -r NUMBER=$((1+RANDOM%999))
declare -i NUMBER
cont=0

function f_read_number() {
  read -p 'Adiviña o número de 3 cifras: ' -n3 number
  declare -i number
  cont=$((cont+1))
}


function f_procure() {
if [ $number -gt $NUMBER ] 2>/dev/null; then
#echo -e "\naaa $?"
  echo -e '\nO número é menor' 
  f_read_number
else 
  if [ $number -lt $NUMBER ] 2>/dev/null; then
#echo -e "\nbbb $?"
    echo -e '\nO número é maior' 
    f_read_number
  else 
#echo -e "\nccc $?"
    if [ $? -ne 2 ]; then
      echo -e "\nPARABÉNS:!!! Adiviñaches o número en $cont intentos"
      exit
    else
      echo -e '\nDebe introducir un número'
      f_read_number
    fi
  fi
fi
f_procure
}


f_main() {
  clear
  echo -e "\n $NUMBER $number"
  f_read_number
  f_procure
}

f_main
