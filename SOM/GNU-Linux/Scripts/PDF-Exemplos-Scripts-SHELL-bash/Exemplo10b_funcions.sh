# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2021-05-07 16:56:07.687172105 +0200

#!/bin/bash             #Liña necesaria para saber que shell executará o script


suma() {                #Definimos a función suma
echo Dame numero        #Pedimos un número
read n1                 #Recollemos o número como valor na variable n1
echo Dame outro numero  #Pedimos outro número
read n2                 #Recollemos o número como valor na variable n2
echo A suma de $n1 e $n2 é: $(($n1+$n2)) #Facemos a suma
}                       #Finaliza a definición da función suma
suma                    #Chamamos á función suma definida antes da chamada nas liñas 9 e 15

echo -------------------
sleep 3
echo -------------------

function suma() {       #Definimos de novo a función suma, pero agora imos facer que multiplique
echo Dame numero        #Pedimos un número
read n1                 #Recollemos o número como valor na variable n1
echo Dame outro numero  #Pedimos outro número
read n2                 #Recollemos o número como valor na variable n2
echo A multiplicación de $n1 x $n2 é: $(($n1*$n2)) #AGORA FACEMOS UNHA MULTIPLICACIÓN E NON UNHA SUMA
}                       #Finaliza a definición da función suma
suma                    #Chamamos á función suma definida antes da chamada nas liñas 22 e 28
