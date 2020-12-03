# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2016-01-19 16:30:38.000000000 +0100

#!/bin/bash

#VARIABLES
cont=1

#FUNCIONS

##Atrapar sinais:
#### <Ctrl>+<c>: SIGGINT (2)
#### <Ctrl>+<z>: SIGTSTP (20)
control_c_z()
{
  echo -e "\n<Ctrl>+<c> ou <Ctrl>+<z>... Vai ser que non"
  cont=$((cont+1))
  if [ $cont -eq 3 ]; then
    VAR='sair'
  fi
}

trap control_c_z 2 20
while [ "$VAR" != 'sair' ]
do
  read x
  echo $x 
done
