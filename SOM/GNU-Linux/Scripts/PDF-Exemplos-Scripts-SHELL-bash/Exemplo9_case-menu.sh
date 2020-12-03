# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2020-12-03 23:16:36.984822465 +0100

#!/bin/bash                             #Liña necesaria para saber que shell executará o script


echo Opcion1. Ver directorio actual     #Amosa por pantalla
echo Opcion2. Ler /tmp                  #Amosa por pantalla
echo Opcion3. Sair                      #Sair
echo Elixe opcion:1,2,3?                #Escoller opcion
read opcion                             #A opción escollida gárdase como valor na variable opcion
case $opcion in                         #Comezo case para facer menu
1) pwd                                  #Se o valor da variable opcion é 1 fanse os seguintes comandos.
   ;;                                   #Toda opción debe acabar con ;;
2) ls /tmp                              #Se o valor da variable opcion é 2 fanse os seguintes comandos.
   ;;                                   #Toda opción debe acabar con ;;
3) exit                                 #Se o valor da variable opcion é 3 fanse os seguintes comandos.
   ;;                                   #Toda opción debe acabar con ;;
*) echo non elixiches nin 1,2,3         #Mensaxe por pantalla
   ;;                                   #Toda opción debe acabar con ;;
esac                                    #Fin case para facer menu
