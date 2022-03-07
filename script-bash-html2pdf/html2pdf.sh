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
  echo Execución errónea. Exemplos execución:
  echo -ne '\e[00m'
  echo -e 'Exemplo1: Orientación Vertical'
  echo -ne '\e[01;77m'
  echo -e '\tbash $0 file.html vt'
  echo -ne '\e[01;33m'
  echo -ne '\e[00m'
  echo -e 'Exemplo2: Orientación Horizontal'
  echo -ne '\e[01;77m'
  echo -e '\tbash $0 file.html hz'
  echo -ne '\e[01;33m'
  echo -ne '\e[00m'
  echo -e 'Exemplo3: Orientación Vertical con Delay(20000ms)'
  echo -ne '\e[01;77m'
  echo -e '\tbash $0 file.html vt 20000'
  echo -ne '\e[01;33m'
  echo -ne '\e[00m'
  echo -e 'Exemplo4: Orientación Horizontal con Delay(20000ms)'
  echo -ne '\e[01;77m'
  echo -e '\tbash $0 file.html hz 20000' 
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

f_orientation() {
  if [ "$2" = 'hz' ] ; then
    export ORIENTATION='-O landscape'
  elif [ "$2" = 'vt' ]; then
    export ORIENTATION=' ' 
  else
    f_help
  fi
}

f_size() {
  if [[ "$3" = 'A3' ]]; then
    export SIZE="-s A3" 
    FILEPDF="${FILE}_A3"
  elif [ -z "$3" ]; then
    export SIZE="-s A4"
    FILEPDF="${FILE}"
  else
    f_help
  fi
}

f_javascriptDelay() {
  if [[ "$4" =~ ^[0-9]+\d*$ ]]; then
    export DELAY="--javascript-delay $4" 
  elif [ -z "$4" ]; then
    export DELAY=' '
  else
    f_help
  fi
}


f_main() {
  f_search
  f_exist
  f_orientation $*
  f_size $*
  f_javascriptDelay $*
  ${HTML2PDF} ${ORIENTATION} ${DELAY} ${SIZE} ${FILE}.html PDF/${FILEPDF}.pdf
}


##main()
([ $# -eq 2 ] || [ $# -eq 3 ] || [ $# -eq 4 ]) && f_main $* || f_help
