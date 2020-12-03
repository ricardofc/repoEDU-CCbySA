# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2020-12-03 22:57:22.833390910 +0100

#!/bin/bash     #Liña necesaria para saber que shell executará o script


echo "O parámetro cero, $0, é o propio nome do script"
echo "Primeiro parámetro que recibo: $1, segundo: $2…"
echo "O número total de parámetros pasados na execución do script(excluido $0) é: $#"
echo "A lista completa de parámetros(excluido $0), separados por un espacio, é $*"
echo "O Identificador do proceso (PID) é $$"
echo "A saída da execución do último comando pode ser correcta(valor cero) ou errónea(valor distinto de cero), sendo neste caso $?"
