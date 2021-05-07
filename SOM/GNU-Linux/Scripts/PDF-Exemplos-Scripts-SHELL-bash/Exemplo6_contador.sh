# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2021-05-07 16:56:07.687172105 +0200

#!/bin/bash             #Liña necesaria para saber que shell executará o script


for i in $(seq 1 10)   #Comeza bucle contador onde a variable i toma o valor de 1 a 10
do                      #facer
echo Valor de i: $i     #Ensina o valor da variable i para cada valor do bucle, así ensina os números de 1 ata 10
done                    #feito

echo -------------------
sleep 3
echo -------------------

for ((i=1;i<=10;i++))  #Comeza bucle contador onde a variable i toma o valor de 1 a 10
do                      #facer
echo Valor de i: $i     #Ensina o valor da variable i para cada valor do bucle, así ensina os números de 1 ata 10
done
