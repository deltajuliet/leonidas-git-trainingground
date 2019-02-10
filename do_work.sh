#!/bin/bash

# This script performs random actions in a directory to simulate file system changes
# By Dan Jones, 2019-02-10

base_dir=`pwd`

#Protects the root directory of the project from being messed with
current_dir_name=${PWD##*/}

if [ ${current_dir_name} == "leonidas-git-trainingground" ]
then
  echo "Please run this from another folder in this repo so that scripts in the root of this repo don't get stepped on."
  exit
fi

number_of_actions=$BASH_ARGV

if [ $number_of_actions -eq ""]
  then
    number_of_actions=25
fi

echo "Making "$number_of_actions" changes in "$base_dir
echo "Enter yes to continue (y/Y):"
read confirm

confirm=$(awk '{print tolower($0)}' <<< "$confirm")
if [ ${confirm} == "y" ] || [ ${confirm} == "yes" ]
then
  echo "Doing work!"
else
  echo "[!] You don't seem committed and we are feeling sorta lazy so we are going to bail out"
  exit
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

action-file_edit () {
  echo "TODO: ADD CODE to edit files"
}

action-file_rm () {
  echo "TODO: ADD CODE to remove files"
}

determine_file () {
  echo "TODO: FINISH ME"
  cd $base_dr



}

get_random_number() {
  number_possible=5
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
      action-file_edit
      ;;
    5)
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
