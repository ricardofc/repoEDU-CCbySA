# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2021-05-07 16:56:07.687172105 +0200

#!/bin/bash                             #Liña necesaria para saber que shell executará o script

##As variables declaradas como "enteiros" en Bash están limitadas ao rango de números enteiros de:
#### 32 bits: dende -2147483648 ata 2147483647 (-2^31 ata 2^31 - 1)
#### 64 bits: dende -9223372036854775808 ata 9223372036854775807 (-2^63 ata 2^63 - 1)

echo Dáme un número                     #Pedimos un númro
read n1                                 #O que se introduce por teclado gárdase como variable n1
[[ $n1 =~ ^-?[0-9]+$ ]] &&              #Co dobre corchete e mediante expresión regular verifícase se a variable n1 é un número enteiro:
                                        ## ^      -> Indica o inicio da cadea n1
                                        ## -?     -> Se coincide cun signo negativo ou non existe signo
                                        ## [0-9]+ -> Coincide con 1 ou mais díxitos do 0 ao 9
                                        ## $      -> Indica o final da cadea.
                                        ## && -> Equivale a then
   [ $(uname -m) = 'x86_64' -a $n1 -ge -9223372036854775808 -a $n1 -le 9223372036854775807 ]  ||  ## If anidado con simple corchete e and (-a). Soamente é verdadeiro se se cumpren todas as condicións. Ademais mediante || tamén débese validar outra condición/s sendo || equivalente a or. Así ou ven as condicións da liña 20 se cumpren ou débense cumprir as condicións da liña 26

    ##Condición1: $(uname -m) = 'x86_64'
    ##-a -> and
    ##Condición2: $n1 -ge -9223372036854775808 
    ##-a -> and
    ##Condición3: $n1 -le 9223372036854775807

   [ $n1 -ge -2147483648 -a  $n1 -le 2147483647 ]  && 

    ##Condición4: $n1 -ge -2147483648
    ##-a -> and
    ##Condición5: $n1 -le 2147483647
    ##&& -> Equivale a then, o que quere dicir que se cumpriou as condicións da liña 20 ou as da liña 26

                                          # ( )   -> Equivale a executarse nunha subshell
    (                                     # Así ( -> Comeza a execución do código "then"
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
    ) || echo 'Solicitouse un número'     # )   -> Finaliza a execución do código "then"
                                          # ||  -> Equivale a else
                                          #echo -> Se o introducido non é un número enteiro amósase esta mensaxe.
