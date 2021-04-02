#!/bin/bash

#CC by SA 4.0 - http://creativecommons.org/licenses/by-sa/4.0/
##DATA: jue abr  1 23:24:18 CEST 2021
##Author:
##Ricardo Feijoo Costa <ricardofc.sistemas[at]gmail.com>

# Estrutura:

##.
##├── bookmark
##│   └── Bookmarking-file.tmp
##├── file.html
##├── numerar-paxinas.sh
##└── make-Bookmark.sh

### bookmark/Bookmarking-file.tmp -> Índice
### file.html -> Ficheiro exemplo html de onde crear o Índice
### numerar-paxinas.sh -> Script a executar para númeras as páxinas e crear un índice do ficheiro PDF/file.pdf
### make-Boormark.sh -> Script a executar para xerar o índice que usará o script numerar-paxinas.sh


##VARIABLES
RAIZ=$(pwd)
FILENAME=$(echo $1 | awk -F'.html' '{print $1}')
TEMPORAL="${RAIZ}/temporal"
TEMPFILE="${TEMPORAL}/bookmarktemp"
TEMPFILE2="${TEMPORAL}/bookmarktemp2"
BOOKMARK="${RAIZ}/bookmark"
BOOKMARKFILE="${BOOKMARK}/Bookmarking-${FILENAME}.tmp"
NUMCODELINES=$(wc -l $1 | cut -d ' ' -f1)
NUMPAGESALL=$(($(grep -c pagebreak $1)+1))
oldIFS="$IFS"
IFS=$'\n'

##FUNCIONS
f_help() {
  clear
  echo
  echo -ne '\e[01;33m'
  echo '#########################################'
  echo -ne '\e[01;33m'
  echo Execución errónea. Exemplo execución:
  echo -ne '\e[00m'
  echo -ne '\e[01;77m'
  echo ""
  echo -e 'Xerar Índice:'
  echo "  bash $0 file.html    #Ficheiro file.html debe marcar as entradas do índice e os saltos de páxina:"
  echo -ne '\e[00m'
  echo -ne '\e[01;77m'
  echo "
  ##Necesaria a existencia de marcas no ficheiro file.html para crear o índice. As marcas seguen a plantilla:
    <span class='BookmarkTitle-Level-1'>Texto a Índice no nivel 1</span>
    <span class='BookmarkTitle-Level-2'>Texto a Índice no nivel 2</span>
    <span class='BookmarkTitle-Level-3'>Texto a Índice no nivel 3</span>
    <span class='BookmarkTitle-Level-4'>Texto a Índice no nivel 4</span>
        ...

  ##Necesaria a existencia de marcas no ficheiro file.html para o salto de páxina. As marcas seguen a plantilla:
    <div class='pagebreak'>&nbsp;</div>
  "
  echo -ne '\e[01;33m'
  echo '#########################################'
  echo -e '\e[00m'
  echo
  exit
}

f_exist(){
 [ ! -d ${TEMPORAL} ] && mkdir ${TEMPORAL}
 [ ! -d ${BOOKMARK} ] && mkdir ${BOOKMARK}
 [ -f ${BOOKMARKFILE} ] && rm -f ${BOOKMARKFILE}
}

f_execute() {
  grep Bookmark $1 | awk -F "<span class='BookmarkTitle-Level-" '{print $2}' | awk -F"</span>" '{print $1}' > ${TEMPFILE}
  while read LINE
  do
    LEVEL=$(echo ${LINE} | cut -d "'" -f1)
    TITLE=$(echo ${LINE} | cut -d ">" -f2-)
    LINEMOD=$(echo ${LINE} | sed -e 's|\[|\\\[|g' -e 's|\]|\\\]|g')
    grep -A${NUMCODELINES} ${LINEMOD} $1 > ${TEMPFILE2} 
    NUMPAGES=$(grep -c -A${NUMCODELINES} pagebreak ${TEMPFILE2})
    echo -e "BookmarkBegin\nBookmarkTitle: ${TITLE}\nBookmarkLevel: ${LEVEL}\nBookmarkPageNumber: $((${NUMPAGESALL} - ${NUMPAGES}))" >> $BOOKMARKFILE
  done < ${TEMPFILE}
  sed -i 's/\&nbsp;/ /g' ${BOOKMARKFILE}
  IFS="${oldIFS}"
}

f_remove(){
 rm -rf ${TEMPORAL}
}

f_main() {
  f_exist
  f_execute $1
  f_remove
}

##main
[ $# -ne 1 ] && f_help || f_main $1
