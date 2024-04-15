# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2021-05-07 16:56:07.687172105 +0200

#!/bin/bash         #Liña necesaria para saber que shell executará o script

#Variable local/global
#Alcance de variables nas funcións. Verificar se a execución dunha función modifica unha variable global:
## Non a modifica cando dentro da función empregamos local ou declare sen opción -g
## Si a modifica no caso contrario

#---------------------------------------
n1=4                #Definimos variable global n1 co valor 4
function f1() {     #Definimos a función f1
  n1=48             #Definimos dentro da función a variable global n1 co valor 48
}                   #Finaliza a definición da función f1
f1                  #Chamamos á función f1
echo $n1 "A función define n1 como variable global co cal modifica o valor inicial n1=4, sendo agora n1=48"
#---------------------------------------


#---------------------------------------
n2=4                #Definimos variable global n2 co valor 4
function f2() {     #Definimos a función f2
  local n2=48       #Definimos dentro da función a variable local n2 co valor 48
}                   #Finaliza a definición da función f2
f2                  #Chamamos á función f2
echo $n2 "A función define n2 como variable local co cal non modifica o valor inicial n2=4"
#---------------------------------------


#---------------------------------------
n3=4                #Definimos variable global n3 co valor 4
function f3() {     #Definimos a función f3
  declare n3=48     #Definimos dentro da función a variable local n3 co valor 48
}                   #Finaliza a definición da función f3
f3                  #Chamamos á función f3
echo $n3 "A función define n3 como variable local co cal non modifica o valor inicial n3=4"
#---------------------------------------


#---------------------------------------
n4=4                #Definimos variable global n4 co valor 4
function f4() {     #Definimos a función f4
  declare -g n4=48  #Definimos dentro da función a variable global n4 co valor 48
}                   #Finaliza a definición da función f4
f4                  #Chamamos á función f4
echo $n4 "A función define n4 como variable global co cal modifica o valor inicial n4=4, sendo agora n4=48"
#---------------------------------------
