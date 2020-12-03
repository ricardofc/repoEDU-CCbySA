# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2020-12-03 23:18:52.603667802 +0100

#!/bin/bash             #Liña necesaria para saber que shell executará o script


suma() {                #Definimos a función suma
echo Dame numero        #Pedimos un número
read n1                 #Recollemos o número como valor na variable n1
echo Dame outro numero  #Pedimos outro número
read n2                 #Recollemos o número como valor na variable n2
echo A suma de $n1 e $n2 é: $(($n1+$n2)) #Facemos a suma
}                       #Finaliza a definición da función suma
suma                    #Chamamos á función suma
