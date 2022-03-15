#!/bin/bash

 # Variables : If we assing a name to set data that is available
 # Function : If we assign a name to set of commands that is function

#...declare a function...
# func_name()
# {
# commands
# commands
# }

#...access a fucntion...

# func_name

Print_Message() {
  echo hello,
  echo good morning,
  echo welcome to devops
  echo "First Argument in Function =$1 "
  a=20
  echo "value of a = $a"
  b=20
  }

  STAT() {
    echo hello
    return 1
    echo bye
    }

## Main Program
a=10
Print_Message DevOps

echo "First Argument in Main Script = $1"
echo "Value of b = $b"

STAT
echo Exit status of function STAT = $?




# First declare a function, then call the function.
# Function will have its own set of special variables
# Variable declared in main program can be written in function and vice versa
# Function is command and it has exit status as well.


