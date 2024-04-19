# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2020-12-03 23:21:41.066062612 +0100

#!/bin/bash             #Liña necesaria para saber que shell executará o script


inicio() {              #Definimos a función inicio
echo Dáme usuario       #Mensaxe por pantalla
read user               #Recollemos o usuario como valor na variable user
testear                 #Chamamos á función testear
}                       #Finaliza a definición da función inicio
testear() {             #Definimos a función testear
if test -d /home/$user  #Comeza condición: Si existe o directorio /home/$user
then                    #entón
    echo O directorio /home/$user existe     #Mensaxe por pantalla
    tar -czvf /home/$user                    #Comando incorrecto para: Empaquetar-Comprimir o directorio /home/$user
    ##tar -czvf $user-backup.tar.bz2 /home/$user    #Comando correcto para: Empaquetar-Comprimir o directorio /home/$user
else                    #senón
    echo O directorio /home/$user non existe #Mensaxe por pantalla
    echo O contido de /home é o seguinte `ls /home` #Ensina o directorio /home para escollera ben o usuario
    inicio                                   #Chamamos á función inicio
fi                      #Finaliza Condición
}                       #Finaliza a definición da función testear
inicio                  #Chamamos á función inicio
