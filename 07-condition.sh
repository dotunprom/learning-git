#!/bin/bash

# case and if are condition commands, if command is widely because it has more options than case command

# ....IF condition....
# if found in three forms

# Simple if
# if [expression]
# then
# commands
# fi

# ...IF ELSE...

# if [ expression ]; then
# commands
# else
# command
# fi

# ...ELIF...

# if [ expression 1 ] ; then
# commands
# elif [ expression 2 ]; then
# commands
# elif [ expression 3]; then
# commands
# else
# commands
# fi

# if [ 1 -eq 1 ]
# then
#   echo Hello
# fi

# Type of expression
# 1. String Tests
# Operators : == , != , -z
# 2. Number Tests
# operators : -eq , -ne , -le , -lt , -gt
# 3. File Tests
# -e : use to check if file exist or not
# https://tlpd.org/LDP/abs/html/fto.html

a="abc"
if [ "$a" == "abc" ]; then
  echo both are equal
fi

if [ "$a" != "abc" ]; then
  echo "both are not equal"
fi

if [ -z "$b" ]; then
  echo b variable is empty
fi


a="abc"
if [ "$a" == "abc" ]; then
  echo both are equal
else
  echo "both are not equal"
fi

# use quote for variables
