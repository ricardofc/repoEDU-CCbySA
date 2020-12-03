# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2017-05-01 22:12:53.000000000 +0200

#!/bin/bash

##FUNCIONS
f_port() {
  unset IPs_on
  unset IPs_off
  ports_TCP=("${!1}")
  index=0
  for i in "${array_IPs[@]}"
  do
    ping -c4 $i 2>/dev/null
    if [ $? -eq 0 ]; then
      IPs_on[$index]=$i
    else
      IPs_off[$index]=$i
    fi
    index=$((index+1))
  done
  for i in "${IPs_on[@]}"
  do
    nc -vz $i "${ports_TCP[@]}"
  done
  declare -p IPs_on
  declare -p IPs_off
}

##VARIABLES
array_ports_TCP=(21 22 23 80 443 445)
array_IPs=('127.0.0.1' 192.168.56.101 10.0.2.10)

##main()
f_port "array_ports_TCP[@]"
