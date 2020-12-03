# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2020-12-03 22:58:22.485605090 +0100

#!/bin/bash     #Liña necesaria para saber que shell executará o script


a=ls            #Definimos variable a co valor ls
echo '$a'       #Comillas simples, non interpreta caracteres especiais coma o carácter $
echo "$a"       #Comillas dobres, interpreta caracteres especiais coma o carácter $ e todo o que se atope entre elas e
                #considerado como un só parámetro
echo `$a`       #Comillas inclinadas, executa o contido dentro das comillas
