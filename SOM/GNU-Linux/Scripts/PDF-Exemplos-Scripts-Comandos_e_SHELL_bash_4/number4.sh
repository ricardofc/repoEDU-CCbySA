# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2017-05-05 00:19:44.000000000 +0200

#!/bin/bash

##man tput && man terminfo

PID=$$

declare -r NUMBER=$((1+RANDOM%999))
declare -i NUMBER
cont=0
declare -r tinicio=$(date +%s)
declare -r tlimite=30

bash cronometro2.sh $(date +%s) $tlimite $PID &

function f_read_number() {
  read -p 'Adiviña o número de 3 cifras: ' -n3 number
  declare -i number
  cont=$((cont+1))
}


function f_procure() {
CHRONEPID=$(pgrep -f cronometro2)
texecucion=$((`date +%s` - tinicio))
while [ $tlimite -gt $texecucion ]
do
  echo -en "\t $(date -u --date @$(($tlimite - $texecucion)) +%M:%S)\r" 
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
	echo -e "\nPARABÉNS:!!! Adiviñaches o número en $cont intentos e $texecucion segundos"
	tput sc
	COLUMNS=$((`tput cols` - 5))
	tput cup 0 $COLUMNS
	COLOR_ORIGINAL=$(tput rmso)
	echo -n "${COLOR_ORIGINAL}     ${COLOR_ORIGINAL}"
	tput rc
        kill $CHRONEPID 1>/dev/null 2>&1
	exit
      else
	echo -e "\nDebe introducir un número"
	f_read_number
      fi
    fi
  fi
##  f_procure
texecucion=$((`date +%s` - tinicio))
done
echo -e "\nRematouse o tempo!!!--------------------------------------"
exit
}


f_main() {
  clear
##  echo -e "\n $NUMBER $number"
  f_read_number
  f_procure
}

f_main
