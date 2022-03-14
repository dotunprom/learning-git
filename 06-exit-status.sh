#!/bin/bash

#Exit status is a number, $? is a special variable  that holds this value
# $? is going to have the exit status of the last executed command
# Range of the exit status is 0-255
# 0 : Global Success
# 1-125 : Some failure from the command
# 125+ : System failure