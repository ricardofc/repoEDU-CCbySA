#!/bin/bash

#CC by SA 4.0 - http://creativecommons.org/licenses/by-sa/4.0/
##DATA: Thu Oct 22 21:34:05 CEST 2020
##Author:
##Ricardo Feijoo Costa <ricardofc.sistemas[at]gmail.com>

# Estrutura:

##.
##├── bookmark
##│   └── Bookmarking-file.tmp
##├── numerar-paxinas.sh
##├── PDF
##│   └── file.pdf

### bookmark/Bookmarking-file.tmp -> Índice
### numerar-paxinas.sh -> Script a executar para númeras as páxinas e crear un índice do ficheiro PDF/file.pdf
### PDF/ -> Cartafol onde se gardan os arquivos PDF
### PDF/file.pdf -> Ficheiro a numerar e crear o índice


##VARIABLES
RAIZ=$(pwd)
TEMPORAL="${RAIZ}/temporal"
BOOKMARK="${RAIZ}/bookmark"
NUMPAGES=$(pdfinfo $1 | grep Pages | awk '{print $NF}')
FILE="pageNumbers"
FILETEX="${FILE}.tex"
FILEPDF="${FILE}.pdf"
ENDFILENAME=$(echo $1 | cut -d'.' -f1)

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
  echo -e 'Exemplo1: Orientación Vertical'
  echo "  bash $0 PDF/file.pdf 0 vt    #Ficheiro PDF/file.pdf non posúe portada na páxina 1"
  echo "  bash $0 PDF/file.pdf 1 vt    #Ficheiro PDF/file.pdf posúe portada na páxina 1, a cal non se numera"
  echo -ne '\e[00m'
  echo -ne '\e[01;77m'
  echo ""
  echo -e 'Exemplo2: Orientación Horizontal'
  echo "  bash $0 PDF/file.pdf 0 hz    #Ficheiro PDF/file.pdf non posúe portada na páxina 1"
  echo "  bash $0 PDF/file.pdf 1 hz    #Ficheiro PDF/file.pdf posúe portada na páxina 1, a cal non se numera"
  echo "
  ##Necesaria a existencia de Bookmarkingall.tmp para crear o índice. Segue a plantilla:
    BookmarkBegin
    BookmarkTitle: Repaso Comandos GNU/Linux - Shell bash
    BookmarkLevel: 1
    BookmarkPageNumber: 1
    BookmarkBegin
    BookmarkTitle: Práctica
    BookmarkLevel: 2
    BookmarkPageNumber: 1
    ...
  "
  echo -ne '\e[01;33m'
  echo '#########################################'
  echo -e '\e[00m'
  echo
  exit
}



f_exist(){
 [ ! -d ${TEMPORAL} ] && mkdir ${TEMPORAL}
}

f_pageNumbersTex(){
    if [ "$1" == 'hz' ]; then
      HZ='\documentclass[12pt,a4paper,landscape]{article}'
      BD='%Borde superior dereito
        \usepackage[top=-0.6cm,bottom=30.34cm,left=29.3cm,right=0cm]{geometry}'
    elif [ "$1" == 'vt' ]; then
      HZ='\documentclass[12pt,a4paper]{article}'
      BD='%Borde inferior dereito
        \usepackage[top=1.54cm,bottom=1.14cm,left=20.4cm,right=0cm]{geometry}'
    else
      f_help
    fi

    cat > ${TEMPORAL}/${FILETEX} << EOF
        ${HZ}
        \usepackage{multido}
        %\pagestyle{headings}
        \pagestyle{plain}
        ${BD}
        %Borde inferior esquerdo
          %\usepackage[top=1.54cm,bottom=1.24cm,left=0cm,right=23.4cm]{geometry}
        %Borde 
        %\usepackage[hmargin=0.1cm,vmargin=0.2cm,nohead,nofoot]{geometry}
        \begin{document}
        \multido{}{ZZZZ}{\vphantom{x}\newpage}
        \end{document}
EOF

    sed -i "s/ZZZZ/${NUMPAGES}/g" ${TEMPORAL}/${FILETEX}
}

f_portadaSenNumerar(){
    #Portada sen numerar
    pdftk ${RAIZ}/$1 cat 1 output ${TEMPORAL}/Portada.pdf
}

f_numerarDoc(){
    #Numerar documento
    cd ${TEMPORAL}
    pdflatex ${TEMPORAL}/${FILETEX}
    cd ${RAIZ}
    pdftk $1 multibackground ${TEMPORAL}/${FILEPDF} output ${TEMPORAL}/allNumbers.pdf
}

f_numerarOverPage1(){
    #Documento numerado a partir da páxina 2
    pdftk ${TEMPORAL}/allNumbers.pdf cat 1-${NUMPAGES} output ${TEMPORAL}/${NUMPAGES}.pdf
}

f_numerarOverPage2(){
    #Documento numerado a partir da páxina 2
    pdftk ${TEMPORAL}/allNumbers.pdf cat 2-${NUMPAGES} output ${TEMPORAL}/${NUMPAGES}.pdf
}

f_joinPortadaDocumentWithoutIndex(){
    #Unir portada sen numerar e o resto do documento numerado a partir da páxina 2
    pdftk ${TEMPORAL}/Portada.pdf ${TEMPORAL}/${NUMPAGES}.pdf cat output ${TEMPORAL}/ALLwithoutIndex.pdf
}

f_docPortadaWithIndex(){
    #Renovar índice do documento final: ALLIndex.pdf
    pdftk ${TEMPORAL}/ALLwithoutIndex.pdf update_info ${BOOKMARK}/Bookmarking-$(basename ${ENDFILENAME}).tmp output ${TEMPORAL}/ALLIndex.pdf
    cp -pv ${TEMPORAL}/ALLIndex.pdf ${RAIZ}/${ENDFILENAME}_pageNumbers.pdf
}

f_docWithIndex(){
    #Renovar índice do documento final: ALLIndex.pdf
    pdftk ${TEMPORAL}/${NUMPAGES}.pdf update_info ${BOOKMARK}/Bookmarking-$(basename ${ENDFILENAME}).tmp output ${TEMPORAL}/ALLIndex.pdf
    cp -pv ${TEMPORAL}/ALLIndex.pdf ${RAIZ}/${ENDFILENAME}_pageNumbers.pdf
}

f_remove(){
 rm -rf ${TEMPORAL}
}


##main
[ $# -ne 3 ] && f_help 
f_exist
f_pageNumbersTex $3
[ $2 != 0 ] && f_portadaSenNumerar $1
f_numerarDoc $1
[ $2 != 0 ] && f_numerarOverPage2 && f_joinPortadaDocumentWithoutIndex && f_docPortadaWithIndex || (f_numerarOverPage1 && f_docWithIndex)
f_remove
