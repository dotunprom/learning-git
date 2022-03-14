#!/bin/bash

read -p 'Enter your name:' name
echo "Your name = $name"

# special variables
# $0-$n, $*/$@ , $#
echo script Name = $0
echo First Argument = $1
echo All Arguments = $*
echo Number of Arguments = $#

