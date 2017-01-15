#!/bin/bash

# Simple script to show a list of ssh machines to select from
default_ssh_machine_list_path="$HOME/.ssh_machine_list"

# List to read from
if [ -z ${SSH_SELECTOR_LIST+x}]; then
  ssh_machine_list_path="$default_ssh_machine_list_path"
else
  ssh_machine_list_path="$SSH_SELECTOR_LIST"
fi

#echo "current machine list : $ssh_machine_list_path"

# open List as a FD
exec 3< "$ssh_machine_list_path"

# Read in list as an array
readarray -u 3 ssh_machine_array

# Close FD
exec 3<&-

# loop count for printing selection
loop_count=0

# print out list with associated numbers
for ssh_address in ${ssh_machine_array[@]}; do
  echo "$loop_count : $ssh_address"
  let "loop_count+=1"
done

# print out message for user input
echo -n "Select Machine to SSH into : "

# read user input and save to varibable
read ssh_machine_selection

# print out confirmation of selection
echo "you selected : ${ssh_machine_array[$ssh_machine_selection]}-- Connecting Now ..."

# connect to selected machine
ssh "${ssh_machine_array[$ssh_machine_selection]}"
