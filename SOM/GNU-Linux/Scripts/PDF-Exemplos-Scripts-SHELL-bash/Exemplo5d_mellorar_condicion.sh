# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2021-05-07 16:56:07.687172105 +0200

#!/bin/bash                             #Liña necesaria para saber que shell executará o script


echo Dáme un número                     #Pedimos un númro
read n1                                 #O que se introduce por teclado gárdase como variable n1
[ $n1 -lt 100 ] && echo O número $n1 é menor que 100 || ( [ $n1 -gt 100 ] && echo O número $n1 é maior que 100 ||  echo O número $n1 é igual a 100 )

# [ ] -> Equivale a if
# &&  -> Equivale a then
# ||  -> Equivale a else
# ( ) -> Equivale a executarse nunha subshell

# [ $n1 -lt 100 ]                       #Inicio Condición: Si o valor de n1 é menor que 100
# &&                                    #entón
  # echo O número $n1 é menor que 100   #Ensina por pantalla unha mensaxe
# ||                                    #senón

  # ( [ $n1 -gt 100 ] && echo O número é maior que 100 ||  echo O número $n1 é igual a 100 ) -> Execución nunha subshell a Condición-2

    # (                                 #Inicio subshell
    # [ $n1 -gt 100 ]                   #Inicio Condición-2:Si o valor de n1 é maior que 100
    # &&                                #entón
    # echo O número $n1 é maior que 100 #Ensina por pantalla unha mensaxe
    # ||                                #senón
    # echo O número $n1 é igual a 100   #Ensina por pantalla unha mensaxe e Fin Condición-2
    # )                                 #Fin subshell e Fin Condición
