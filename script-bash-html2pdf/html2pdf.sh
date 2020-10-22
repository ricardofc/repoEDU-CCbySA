#!/bin/bash

#CC by SA 4.0 - http://creativecommons.org/licenses/by-sa/4.0/
##DATA: Thu Oct 22 21:34:05 CEST 2020
##Author:
##Ricardo Feijoo Costa <ricardofc.sistemas[at]gmail.com>

# Estrutura:

##.
##├── css
##│   └── styles.css
##├── html2pdf.sh
##├── images
##│   ├── 88x31.png
##│   └── license-image-88x31.png.txt
##├── PDF
##└── template.html

### css/styles.css -> Estilo css
### html2pdf.sh -> Script a executar para convertir ficheiros html a PDF
### images/88x31.png -> Imaxe licenza CCbySA
### images/license-image-88x31.png.txt -> URL imaxe licenza CCbySA
### PDF/ -> Cartafol onde se gardan os arquivos PDF
### template.html -> Ficheiro exemplo html a convertir en PDF


##VARIABLES
HTML2PDF=$(which wkhtmltopdf)
FILE=$(echo $1 | awk -F'.html' '{print $1}')

##FUNCTIONS
f_help() {
  clear
  echo
  echo -ne '\e[01;33m'
  echo '#######################################################'
  echo -ne '\e[01;33m'
  echo Execución errónea. Exemplo execución:
  echo -ne '\e[00m'
  echo -ne '\e[01;77m'
  echo bash $0 file.html
  echo -ne '\e[01;33m'
  echo '#######################################################'
  echo -e '\e[00m'
  echo
  exit
}

f_install() {
  clear
  echo
  echo -ne '\e[01;33m'
  echo '#######################################################'
  echo -ne '\e[01;33m'
  echo 'Debe instalar paquete wkhtmltopdf. Por exemplo executar:'
  echo -ne '\e[00m'
  echo -ne '\e[01;77m'
  echo 'apt update && apt -y install wkhtmltopdf'
  echo -ne '\e[01;33m'
  echo '#######################################################'
  echo -e '\e[00m'
  echo
  exit
}

f_search() {
  [ ! ${HTML2PDF} ] && f_install
}

f_verify() {
  clear
  echo
  echo -ne '\e[01;33m'
  echo '#######################################################'
  echo -ne '\e[01;33m'
  echo "${FILE}.html non existe. Verifique o nome do ficheiro:"
  echo -ne '\e[00m'
  echo -ne '\e[01;77m'
  echo "ls -l ${FILE}.html"
  echo -ne '\e[01;33m'
  echo '#######################################################'
  echo -e '\e[00m'
  echo
  exit
}

f_exist() {
  [ ! -f ${FILE}.html ] && f_verify
}

f_main() {
  f_search
  f_exist
  ${HTML2PDF} ${FILE}.html PDF/${FILE}.pdf
}


##main()
[ $# -ne 1 ] && f_help || f_main
