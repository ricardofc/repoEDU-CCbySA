# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
# Creative Commons License: http://creativecommons.org/licenses/by-sa/4.0/
# Author: Ricardo Feijoo Costa 
# DATA: 2024-04-14 20:55:15.717415352 +0100

#!/bin/bash

env | sort | grep -v '^_' | tee env1.txt
cd /tmp
