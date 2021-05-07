# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2021-05-07 16:56:07.687172105 +0200

#!/bin/bash             #Liña necesaria para saber que shell executará o script


echo Dáme o teu nome    #Pedimos o nome do usuario
read nome               #O que se introduce por teclado gárdase como variable nome
echo Ola $nome          #Ensinamos por pantalla Ola e o contido da variable nome

read -p 'Dáme o teu nome ' nome   #Pedimos o nome do usuario é o que se introduce por teclado gárdase como variable nome
echo Ola $nome                   #Ensinamos por pantalla Ola e o contido da variable nome
