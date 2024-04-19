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
