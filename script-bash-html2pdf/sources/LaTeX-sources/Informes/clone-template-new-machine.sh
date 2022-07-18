#!/bin/bash

#CC by SA 4.0 - http://creativecommons.org/licenses/by-sa/4.0/
##DATA: jue 07 jul 2022 01:05:27 CEST
##Author:
##Ricardo Feijoo Costa <ricardofc.sistemas[at]gmail.com>

##VARIABLES
RAIZ=$(pwd)

##FUNCIONS
function f_help() {
  clear
  echo
  echo -ne '\e[01;33m'
  echo '#########################################'
  echo -ne '\e[01;33m'
  echo Execución errónea. Exemplo execución:
  echo -ne '\e[00m'
  echo -ne '\e[01;77m'
  echo ""
  echo "  bash $0 Love    #O nome da máquina é Love"
  echo -ne '\e[00m'
  echo -ne '\e[01;77m'
  echo ""
  echo -ne '\e[01;33m'
  echo '#########################################'
  echo -e '\e[00m'
  echo
  exit
}

function f_clone(){
cp -Rav ${RAIZ}/Template ${RAIZ}/$1
nameMachine=$(echo $1 | tr 'A-Z' 'a-z')
rename "s/template/${nameMachine}/" ${RAIZ}/$1/*
rename "s/template/${nameMachine}/" ${RAIZ}/$1/images/*
sed -i -e "s/template/${nameMachine}/g" -e "s/Template/$1/g" ${RAIZ}/$1/${nameMachine}.tex
}

function f_exist(){
 [ ! -d "${RAIZ}/$1" ] && f_clone $1 && f_remember $1 || echo 'O nome da máquina xa existe'
}

function f_remember(){
echo -ne '\e[01;33m'
  echo --------------------------------------
  echo cd $1
  echo latexmk -pdf -pvc ${nameMachine}.tex
  echo vim ${nameMachine}.tex
  echo --------------------------------------
echo -ne '\e[00m'
}

function f_main(){
f_exist $1
}

##main
[ $# -ne 1 ] && f_help || f_main $1
