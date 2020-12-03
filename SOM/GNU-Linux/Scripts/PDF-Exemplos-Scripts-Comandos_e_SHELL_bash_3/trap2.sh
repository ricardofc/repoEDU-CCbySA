# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2016-01-19 16:55:18.000000000 +0100

#!/bin/bash

##VARIABLES
cont=1

##FUNCIÓNS

#Atrapar sinal <Ctrl>+<c>: SIGGINT (2)
function control_c()
{
  echo -e "\n<Ctrl>+<c> ... Vai ser que non"
  cont=$(($cont+1))
}

#Atrapar sinal <Ctrl>+<z>: SIGTSTP (20)
function control_z()
{
  echo -e "\n<Ctrl>+<z> ... Vai ser que non"
  cont=$(($cont+1))
}


##main() 
trap control_c SIGINT #Executa a función control_c como acción para o sinal SIGINT 
trap control_z SIGTSTP #Executa a función control_z como acción para o sinal SIGSTP

while [ $cont -lt 3 ]
do
  read x
  echo $x
done
