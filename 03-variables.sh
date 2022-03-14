#!/bin/bash

a=100
b=devops
echo ${a}time
echo ${b}

#{} are needed if variables is combined with other words with out space

DATE=2022-03-10
echo Today date is $DATE

DATE=$(date +%F)
echo Today date is $Date

x=10
y=20
ADD=$(($x+$y))
echo Add = $ADD

#Arrays
c=(10 20 small large)
echo First Value of Array = ${c[0]}
echo Third Value of Array = ${c[2]}
echo All Value of Array = ${c[*]}
