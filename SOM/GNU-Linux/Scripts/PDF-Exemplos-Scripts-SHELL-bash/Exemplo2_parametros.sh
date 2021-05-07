# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2021-05-07 16:56:07.687172105 +0200

#!/bin/bash     #Liña necesaria para saber que shell executará o script

#Exemplo de execución:
# bash Exemplo2_parametros.sh 1 2 3 4 5 6 7 8 9 a b c 

echo "Parámetro \$0 -> Nome do script"
echo -e "\t \$0 toma o valor $0\n"

echo "Parámetros posicionais \$1, \$2, \$3, \$4,..., \$9, \${10}, \${11}, \${12}, \${n} -> Parámetros que recibe o script como argumentos"
echo -e "\t \$1 toma o valor $1\n"
echo -e "\t \$2 toma o valor $2\n"
echo -e "\t \$3 toma o valor $3\n"
echo -e "\t \$4 toma o valor $4\n"
echo -e "\t \$5 toma o valor $5\n"
echo -e "\t \$6 toma o valor $6\n"
echo -e "\t \$7 toma o valor $7\n"
echo -e "\t \$8 toma o valor $8\n"
echo -e "\t \$9 toma o valor $9\n"
echo -e "\t \$10 toma o valor $10\n"
echo -e "\t \${10} toma o valor ${10}\n"
echo -e "\t \t \$10 é distinto a \${10}\n"
echo -e "\t \${11} toma o valor ${11}\n"
echo -e "\t \${12} toma o valor ${12}\n"
echo -e "\t \${13} toma o valor ${13}\n"
echo -e "\t \${14} toma o valor ${14}\n"
echo -e "\t \${15} toma o valor ${15}\n"

echo "Parámetro \$# -> Número total de parámetros recibidos na execución do script(excluido \$0)"
echo -e "\t \$# toma o valor $#\n"

echo -e "Comprobamos o separador interno de campo IFS"
IFS=$' \t\n'
set | grep IFS
oldIFS=$IFS
echo "Parámetro \$* -> Lista completa de parámetros(excluido \$0), separados por un espazo"
echo -e "\t \$* toma o valor $*\n"

echo "Parámetro \$@ -> Lista completa de parámetros(excluido \$0), separados por un espazo"
echo -e "\t \$@ toma o valor $@\n"

echo -e "\t \$* e \$@ son equivalentes sempre que o IFS posúa como primeiro caracter de separación o caracter espazo. (IFS afecta a \$*)\n\n"
echo -e "\tCambiamos o separador interno de campo IFS"
IFS='Ñ\t\n'
set | grep IFS | grep -v old
echo "Voltamos a executar:"
echo -e "\t \$* toma o valor $*\n"
echo -e "\t \$@ toma o valor $@\n"
echo -e "\t Devolvemos IFS ao valor orixinal"
IFS=$oldIFS
set | grep IFS | grep -v old

echo -e "\nParámetro \$\$ -> Identificador do proceso (PID)"
echo -e "\t \$\$ toma o valor $$\n"

echo "Parámetro \$? -> O estado da saída da execución do último comando, a cal pode ser correcta(valor cero) ou errónea(valor distinto de cero)"
echo -e "\t Execución comando pwd" 
  pwd
echo -e "\t \$? toma o valor $?\n"

echo -e "\t Execución comando abcabc" 
  $(abcabc)
echo -e "\t \$? toma o valor $?"
