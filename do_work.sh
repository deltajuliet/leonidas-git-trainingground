#!/bin/bash

# This script performs random actions in a directory to simulate file system changes
# By Dan Jones, 2019-02-10

base_dir=`pwd`

number_of_actions=$BASH_ARGV

if [ $number_of_actions -eq ""]
  then
    number_of_actions=5
fi

action-dir_add () {
  echo "TODO: ADD CODE to add directory"
}

action-dir_rm () {
  echo "TODO: ADD CODE to rm directory"
}

action-file_add () {
  echo "TODO: ADD CODE to add files"
}

action-file_rm () {
  echo "TODO: ADD CODE to remove files"
}

determine_file () {
  echo "TODO: ADD CODE"
}

get_random_number() {
  number_possible=4
  return $((($RANDOM % $number_possible)+1))
}

take_action () {
  case $1 in
    1)
      action-dir_add
      ;;
    2)
      action-dir_rm
      ;;
    3)
      action-file_add
      ;;
    4)
      action-file_rm
      ;;
  esac
}

counter=0
while [ $counter -lt $number_of_actions ]
do
  counter=$(expr $counter + 1)
  
  get_random_number
  action=$?

  take_action $action
done
