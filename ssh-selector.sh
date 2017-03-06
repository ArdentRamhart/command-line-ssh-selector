#!/bin/bash

# Simple script to show a list of ssh machines to select from

#defult machine list location
default_ssh_machine_list_path="$HOME/.ssh_machine_list"
verbose_output=false

# List to read from, checking for environmental variable
if [ -z "${SSH_SELECTOR_LIST+x}" ]; then
  ssh_machine_list_path="$default_ssh_machine_list_path"
else
  ssh_machine_list_path="$SSH_SELECTOR_LIST"
fi

# reading Get opts
while getopts ":v" opt; do
  case $opt in
    v)
      verbose_output=true
      ;;
    \?)
      echo "invalid option: -$OPTARG" >&2
      ;;
    esac
done

if $verbose_output; then
  echo "INFO: current machine list - $ssh_machine_list_path"
fi

#check for file and error out if not exsist
if [ ! -f "$ssh_machine_list_path" ]; then
  echo "ERROR: No Such File - $ssh_machine_list_path" 1>&2
  exit 1
fi


# open List as a FD
#exec 3< "$ssh_machine_list_path"

# Read in list as an array
#readarray -u 3 ssh_machine_array

# Close FD
#exec 3<&-

# loop count for printing selection
server_count=`jq '. | length' $ssh_machine_list_path`
if $verbose_output; then
  echo "INFO: current machine list length : $server_count"
fi

# print out list with associated numbers
for ((i=0; i<$server_count; i++)); do
  server_name=$( jq ".[$i]["\""serverName"\""]" $ssh_machine_list_path )
  list_output="$i : $server_name"
  if $verbose_output; then
    server_ip=$( jq ".[$i]["\""ip"\""]" $ssh_machine_list_path )
    list_output="$list_output | ip: $server_ip"
  fi
  echo "$list_output"
done

# print out message for user input
echo -n "Select Machine to SSH into : "

# read user input and save to varibable
read ssh_machine_selection

# reading the server name and ip from the list
server_name=$(jq ".[$ssh_machine_selection]["\""serverName"\""]" $ssh_machine_list_path )
server_ip=$(jq ".[$ssh_machine_selection]["\""ip"\""]" $ssh_machine_list_path )

# stripping double quotes from ip and server name
server_name=${server_name:1:-1}
server_ip=${server_ip:1:-1}

# print out confirmation of selection
echo "you selected : $server_name -- Connecting Now ..."
if $verbose_output; then
  echo "INFO: selected machine ip : $server_ip"
fi

# connect to selected machine
ssh $server_ip
