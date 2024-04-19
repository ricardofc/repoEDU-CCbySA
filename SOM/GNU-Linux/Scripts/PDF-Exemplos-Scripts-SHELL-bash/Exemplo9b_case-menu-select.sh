# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2020-12-03 23:16:36.984822465 +0100

#!/bin/bash                             #Liña necesaria para saber que shell executará o script

PS3='Elixe opción:1,2,3? '              #Definir o valor da variable PS3 para establecer o prompt do comando select.
OPCION1='Ver directorio actual'         #Definir a variable OPCION1 co valor da primeira opción do menú.
OPCION2='Ler /tmp'                      #Definir a variable OPCION2 co valor da segunda opción do menú.
OPCION3='Saír'                          #Definir a variable OPCION3 co valor da terceira opción do menú.

select opcion in "${OPCION1}" "${OPCION2}" "${OPCION3}"         #Inicia o bucle select coas opcións definidas
do 
  case ${opcion} in                         #Comezo case para facer menu
    ${OPCION1}) pwd                           #Se o valor da variable opcion é o valor da variable OPCION1 (Ver directorio actual) fanse os seguintes comandos.
       ;;                                     #Toda opción debe acabar con ;;
    ${OPCION2}) ls /tmp                       #Se o valor da variable opcion é o valor da variable OPCION2 (Ler /tmp) fanse os seguintes comandos.
       ;;                                     #Toda opción debe acabar con ;;
    ${OPCION3}) exit                          #Se o valor da variable opcion é o valor da variable OPCION3 (Saír) fanse os seguintes comandos.
       ;;                                     #Toda opción debe acabar con ;;
    *) echo Non elixiches nin 1,2,3           #Mensaxe por pantalla no caso de non elixir unha das opcións anteriores
       ;;                                     #Toda opción debe acabar con ;;
  esac                                      #Fin case para facer menu
done                                                            # Finaliza o bucle select.
