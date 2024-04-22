#!/bin/bash
# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2024-04-14 20:55:15.717415352 +0100

#!/bin/bash

PS3='Opción? '
opcions=("Ver directorio actual" "Ler /tmp" "Saír")
select opcion in "${opcions[@]}"
do
  case $opcion in
    "Ver directorio actual") pwd
                             break
                             ;;
    "Ler /tmp") ls /tmp
                break
                ;;

    "Saír") break
            ;;

    *) echo "Non elixiches ningunha opción válida";;
  esac
done
