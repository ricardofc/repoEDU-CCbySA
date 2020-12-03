# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2020-12-03 23:13:03.478047752 +0100

#!/bin/bash             #Liña necesaria para saber que shell executará o script


i=1                     #Definimos variable i co valor un.
while [ $i -le 100 ]    #Comeza bucle contador onde a variable i toma o valor de 1 a 100: Namentras i sexa menor ou igual a 100
do                      #facer
    echo Valor de i: $i #Ensina o valor da variable i para cada valor do bucle, sendo o primeiro valor un
    i=$(($i+1))         #Aumenta unha unidade o valor anterior, se era un, entón agora valor igual a dous
done                    #feito
