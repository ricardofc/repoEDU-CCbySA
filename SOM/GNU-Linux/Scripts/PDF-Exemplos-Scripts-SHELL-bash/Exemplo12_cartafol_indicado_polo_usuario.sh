# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2020-12-03 23:25:01.960086187 +0100

#!/bin/bash             #Liña necesaria para saber que shell executará o script


inicio() {              #Definimos a función inicio
echo Dáme cartafol      #Menxase por pantalla
read cartafol           #Recollemos o escrito como valor na variable cartafol
testear                 #Chamamos á función testear
}                       #Finaliza a definición da función inicio
testear() {             #Definimos a función testear
if test -d $cartafol    #Comeza Condición: Si existe o directorio $cartafol
then                    #entón,
    echo O directorio $cartafol existe      #Mensaxe por pantalla
    tar -czvf $cartafol                     ##Comando incorrecto para: Empaquetar e comprimir o directorio $cartafol
    ##tar -czvf $cartafol-backup.tar.bz2 $cartafol    ##Comando correcto para: Empaquetar e comprimir o directorio $cartafol
else                    #senón
    echo O directorio $cartafol non existe  #Mensaxe por pantalla
    inicio                                  #Chamamos á función inicio
fi                      #Finaliza a condición
}                       #Finaliza a definición da función testear
inicio                  #Chamamos á función inicio
