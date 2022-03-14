#!/bin/bash

echo Hello World.

## Color codes
# Red       31
# Green     32
# Yellow    33
# Blue      34
# Magenta   35
# Cyan      36

# Syntax : echo -e "\e[COLmHello\0M["
# -e option is not enabled esc seq. without -e colors will not work
# "" or '' Quote are mandatry for color to work.
# \e[COLm : this to enable the color  COL is one of the color code.
# \e[0m : disable the color

echo -e "\e[31mText i red color"
echo "One more line"