#!/bin/bash

source ./functions.sh

test="1 2 3 4 5 6 7"

string_2_array "$test" " "

echo ${s2a_output[@]}
