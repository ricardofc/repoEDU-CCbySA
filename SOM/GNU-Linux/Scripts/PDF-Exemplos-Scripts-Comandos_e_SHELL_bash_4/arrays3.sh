# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2017-05-01 23:26:01.000000000 +0200

#!/bin/bash

##FUNCIONS
f_port() {
  clear
  unset IPs_ports_TCP_on IPs_ports_TCP_off
  ports_TCP=("${!1}")
  index_IPs_on=0
  index_IPs_off=0
  index_ports_TCP_on=0
  index_ports_TCP_off=0
  for i in "${array_IPs[@]}"
  do
    ping -c4 $i 1>/dev/null 2>&1
    if [ $? -eq 0 ]; then
      IPs_on[${index_IPs_on}]=$i
      for j in "${ports_TCP[@]}"
      do
	nc -vz $i $j 1>/dev/null 2>&1
	if [ $? -ne 0 ]; then
	  ports_TCP_off[${index_ports_TCP_off}]=$j  
          IPs_ports_TCP_off[${index_ports_TCP_off}]="$i $j"  
	  index_ports_TCP_off=$((${index_ports_TCP_off}+1))
	else
	  ports_TCP_on[${index_ports_TCP_on}]=$j
	  IPs_ports_TCP_on[${index_ports_TCP_on}]="$i $j"
	  index_ports_TCP_on=$((${index_ports_TCP_on}+1))
	fi
      done
      index_IPs_on=$((${index_IPs_on}+1))
    else
      IPs_off[${index_off}]=$i
      index_IPs_off=$((${index_off}+1))
    fi
  done
  echo "###################"
  echo "IPs on e portos on:"
  declare -p IPs_ports_TCP_on
  ##echo "${IPs_ports_TCP_on[@]}"
  echo 
  echo "IPs on e portos off:"
  declare -p IPs_ports_TCP_off
  ##echo "${IPs_ports_TCP_off[@]}"
  echo
  echo "IPs off:"
  declare -p IPs_off
  ##echo "${IPs_off[@]}"
  echo "###################"
}

##VARIABLES
array_ports_TCP=(21 22 23 80 443 445)
array_IPs=('127.0.0.1' 192.168.56.101 10.0.2.10)

##main()
f_port "array_ports_TCP[@]"
