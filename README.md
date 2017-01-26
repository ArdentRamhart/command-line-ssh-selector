# command-line-ssh-selector
simple command line tool for selecting machines to ssh into.

Reads a list of severs from a new line delimited file and allows you to select one to ssh into.  

## Setup
Reads a list of servers from a new line delimited file
will use environmental variable `SSH_SELECTOR_LIST`
will default to `$HOME/.ssh_machine_list` if environmental variable doesn't exists

just add this file with a list of servers that you ssh into.

## How To Run
make the script executable and run it in the command line

## Arguments

### -v
Verbose Output of script
