# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2020-12-03 23:13:03.478047752 +010

#!/bin/bash             #Liña necesaria para saber que shell executará o script


i=1                     #Definimos variable i co valor 1.
while [ $i -le 10 ]     #Comeza bucle contador onde a variable i toma o valor de 1 a 10: Namentras i sexa menor ou igual a 10
do                      #facer
    echo Valor de i: $i #Ensina o valor da variable i para cada valor do bucle, sendo o primeiro valor 1
    i=$(($i+1))         #Aumenta unha unidade o valor anterior, se era 1, entón agora valor igual a 2
done                    #feito

echo -------------------
sleep 3
echo -------------------

# Creación ficheiro file.csv
cat > file.csv <<EOF
user;contrasinal;bash;uid;gid
user1;abc123.;false;1051;1051
user2;abc123.;bash;1052;1052
user3;abc123.;bash;1053;1053
user4;abc123.;false;1054;1054
EOF

while read LINE         #Comeza bucle a percorrer cada liña(LINE) do ficheiro
do                      #facer
    echo $LINE          #Ensina o valor da variable LINE, sendo o primeiro valor a primeira liña do ficheiro chamado a percorrer o bucle
    sleep 2             #Esperar 2 segundos para continuar co bucle
done < file.csv         #feito e chamada ao ficheiro a percorrer o bucle


echo -------------------
sleep 3
echo -------------------

cat file.csv | while read LINE         #Chamada ao ficheiro e Comeza bucle a percorrer cada liña(LINE) do ficheiro
do                                     #facer
    echo $LINE                         #Ensina o valor da variable LINE, sendo o primeiro valor a primeira liña do ficheiro chamado a percorrer o bucle
    sleep 2                            #Esperar 2 segundos para continuar co bucle
done                                   #feito
