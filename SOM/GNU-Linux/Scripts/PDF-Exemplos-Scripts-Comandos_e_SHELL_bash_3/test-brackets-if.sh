# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2016-02-05 17:53:52.000000000 +0100

#!/bin/bash

######################################################################################
[ -f /etc/passwd ] && grep root /etc/passwd

if [ -f /etc/passwd ]; then
  grep root /etc/passwd
fi


######################################################################################
[ -d $HOME ] && mkdir -p $HOME/bin/scripts

if [ -d $HOME ]; then 
  mkdir -p $HOME/bin/scripts
fi


######################################################################################
[ -r $HOME/bin/scripts/comprobar.sh ] && cat $HOME/bin/scripts/comprobar.sh

if [ -r $HOME/bin/scripts/comprobar.sh ]; then 
  cat $HOME/bin/scripts/comprobar.sh
fi


######################################################################################
[ -r $HOME/bin/scripts/comprobar.sh ] &&  [ -x $HOME/bin/scripts/comprobar.sh ] && . $HOME/bin/scripts/comprobar.sh

if [ -r $HOME/bin/scripts/comprobar.sh ]; then
  if  [ -x $HOME/bin/scripts/comprobar.sh ]; then 
    . $HOME/bin/scripts/comprobar.sh
  fi
fi


######################################################################################
[ -r $HOME/bin/scripts/comprobar.sh ] || [ -x $HOME/bin/scripts/comprobar.sh ] && . $HOME/bin/scripts/comprobar.sh 

if [ -r $HOME/bin/scripts/comprobar.sh ] || [ -x $HOME/bin/scripts/comprobar.sh ]; then 
    . $HOME/bin/scripts/comprobar.sh
fi


######################################################################################
[ -r $HOME/bin/scripts/comprobar.sh ] && bash /bin/scripts/comprobar.sh || echo "Non se executa o script"
 
if [ -r $HOME/bin/scripts/comprobar.sh ]; then
  bash $HOME/bin/scripts/comprobar.sh
else
  echo "Non se executa o script"
fi
