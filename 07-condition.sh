#!/bin/bash

# case and if are condition commands, if command is widely because it has more options than case command

# ....IF condition....
# if found in three forms

# Simple if
# if [expression]
# then
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
# 3. File Tests

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

