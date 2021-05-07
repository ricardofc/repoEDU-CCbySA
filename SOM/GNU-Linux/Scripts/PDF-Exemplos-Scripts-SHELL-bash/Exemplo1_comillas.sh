# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2021-05-07 16:56:07.687172105 +0200

#!/bin/bash       # Liña necesaria para saber que shell executará o script

a=ls              # Definimos variable a co valor ls

echo 1 '$a'       # Entrecomillado comillas simples -> amosa $a
                    # Comillas simples -> NON interpreta carácteres especiais: $(dólar)  `(comilla inclinada) \(barra invertida=carácter de escape), *(asterisco), @(arroba)
                    # Comillas simples -> o entrecomillado PRESERVA o VALOR LITERAL de cada carácter
                    # Unha comilla simple no entrecomillado de cómillas simples -> ERRO -> aínda que esté precedida do carácter de escape \ unha comilla simple NON pode estar entre comillas simples -> ver echo 23


echo 2 "$a"       # Entrecomillado comillas dobres -> amosa ls
                    # Comillas dobres -> SI interpreta carácteres especiais: $(dólar)  `(comilla inclinada) \(barra invertida=carácter de escape), *(asterisco), @(arroba)
                    # Comillas dobres -> Valor literal para carácteres non especiais
                    # Comillas dobres -> todo o entrecomillado é considerado como un só parámetro
                    # Unha comilla dobre no entrecomillado de comillas dobres -> SI pode existir unha comilla dobre precedida do carácter de escape \ -> ver echo 24

echo 3 `$a`       # Entrecomillado comillas inclinadas -> executa o contido dentro das comillas -> executa ls

echo 4 $($a)      # Equivale ao comando anterior: `$a`



echo 5 "'$a'"     # Comillas dobres -> interpreta carácter $ -> expande $a -> comillas simples -> valor literal -> amosa 'ls'

echo 6 "`$a`"     # Comillas dobres -> interpreta carácter $ -> expande $a -> comillas inclinadas -> executa ls

echo 7 "$($a)"    # Equivale ao comando anterior: "`$a`"



echo 8 '"$a"'     # Comillas simples -> valor literal -> amosa "$a"

echo 9 '`$a`'     # Comillas simples -> valor literal -> amosa `$a`

echo 10 '$($a)'   # Comillas simples -> valor literal -> amosa $($a)



echo 11 ''$a      # Comillas simples duplicadas -> no seu entrecomillado non existe nada -> consideradas como se non existiran -> equivale a $a -> ver echo 2

##echo 12 ''$a'     # Comillas simples impares -> erro sintáctico
                    # As dúas primeiras comillas simples traballan en conxunto -> no seu entrecomillado non existe nada -> a última comilla simple ésta á espera de ser pechada por outra comilla simple

echo 13 ''$a\'    # Comillas simples duplicadas -> no seu entrecomillado non existe nada -> consideradas como se non existiran -> expándese $a -> escápase o carácter comilla simple -> amosa ls'

echo 14 ''$a''    # Comillas simples duplicadas -> no seu entrecomillado non existe nada -> consideradas como se non existiran -> equivale a $a -> ver echo 2

echo 15 ''`$a`''  # Comillas simples duplicadas -> no seu entrecomillado non existe nada -> consideradas como se non existiran -> ver echo 3

echo 16 ''$($a)'' # Comillas simples duplicadas -> no seu entrecomillado non existe nada -> consideradas como se non existiran -> ver echo 4



echo 17 ""$a      # Comillas dobres duplicadas -> no seu entrecomillado non existe nada -> consideradas como se non existiran -> equivale a $a -> ver echo 2

##echo 18 ""$a"     # Comillas dobres impares -> erro sintáctico
                    # As dúas primeiras comillas dobres traballan en conxunto -> no seu entrecomillado non existe nada -> a última comilla dobre ésta á espera de ser pechada por outra comilla dobre

echo 19 ""$a\"    # Comillas dobres duplicadas -> no seu entrecomillado non existe nada -> consideradas como se non existiran -> expándese $a -> escápase o carácter comilla dobre -> amosa ls"

echo 20 ""$a""    # Comillas dobres duplicadas -> no seu entrecomillado non existe nada -> consideradas como se non existiran -> equivale a $a -> ver echo 2

echo 21 ""`$a`""  # Comillas dobres duplicadas -> no seu entrecomillado non existe nada ->  consideradas como se non existiran -> ver echo 3

echo 22 ""$($a)"" # Comillas dobres duplicadas -> non seu entrecomillado non existe nada -> consideradas como se non existiran -> ver echo 4



##echo 23 '\''      # Comillas simples impares -> unha comilla simple escapada non funciona -> consola á espera de pechar a sintaxe do comando con outra comilla simple

echo 24 "\""      # Comillas dobres impares -> unha comilla dobre escapada -> consideráse valor literal -> amosa "
