# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2017-05-05 22:52:50.000000000 +0200

#!/bin/bash

declare -r tinicio=$(date +%s)
declare -r tlimite=30

tagora=$(date +%s)
texecucion=$((tagora-tinicio))
while [ $tlimite -gt $texecucion ]
do
tagora=$(date +%s)
texecucion=$((tagora-tinicio))
  echo -en "\t $(date -u --date @$(($tlimite - $texecucion)) +%M:%S)\r"
done
