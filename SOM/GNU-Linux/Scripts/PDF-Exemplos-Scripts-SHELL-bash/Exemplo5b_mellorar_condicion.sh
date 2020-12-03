# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2020-12-03 23:07:20.396113895 +0100

#!/bin/bash                             #Liña necesaria para saber que shell executará o script


echo Dáme un número                     #Pedimos un númro
read n1                                 #O que se introduce por teclado gárdase como variable n1
if test $n1 -le 100                     #Inicio Condición: Si o valor de n1 é menor ou igual que 100
then                                    #entón
    if test $n1 -lt 100 ;then           #Inicio Condición-2:Si o valor de n1 é menor que 100
      echo O número $n1 é menor que 100 #Ensina por pantalla unha mensaxe
    else                                #senón
      echo O número é igual a 100       #Ensina por pantalla unha mensaxe
    fi                                  #Fin Condición-2
else                                    #senón
    echo O número $n1 é maior que 100   #Ensina por pantalla unha mensaxe
fi                                      #Fin Condición
