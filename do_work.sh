#!/bin/bash

# This script performs random actions in a directory to simulate file system changes
#
# !!! WARNING: Changes to this script could cause file modifications all over a system
#
# By Dan Jones, 2019-02-10
shopt -s expand_aliases

acceptable_project_name="leonidas-git-trainingground"
base_dir=`pwd`
max_depth=5 #Farthest recursion possible
wordfile="/usr/share/dict/words" #File used for creating file content and names

#Protects the root directory of the project from being messed with
current_dir_name=${PWD##*/}

if [ ${current_dir_name} == ${acceptable_project_name} ]
then
  echo "Please run this from another folder in this repo so that scripts in the root of this repo don't get stepped on."
  exit
fi

# Tests to ensure that shuf is installed. 
shuf_installed=$(which shuf)
if [ "$shuf_installed" == "" ]
then
  gshuf_installed=$(which gshuf)
  if [ "$gshuf_installed" == "" ]
  then
    echo "Not installed"
    echo "It looks like shuf or gshuf are not installed. If you are on a Mac try: brew install coreutuls"
    exit 1
  else
    alias shuf="gshuf"
  fi
fi

echo "Ready go to work! How many actions do you need me to perform?"
read number_of_actions
echo "Going to do some work. $number_of_actions actions"

confirm () {
  echo "Making "$number_of_actions" changes in "$base_dir
  echo "Enter yes to continue (y/Y):"
  read confirm

  confirm=$(awk '{print tolower($0)}' <<< "$confirm")

  if [ ${confirm} == "y" ] || [ ${confirm} == "yes" ]
  then
    echo "Doing work!"
  else
    echo "[!] You don't seem committed and we are feeling sorta lazy so we are going to bail out"
    exit 1
  fi
}

#confirm #Turns on confirmation requirements before running

#Moves to the base dir and then finds a location to take an action at
determine_cur_dir_count () {
  dir_count=$(ls -d */ 2> /dev/null | wc -l)
  echo $dir_count
}

determine_cur_file_count () {
  file_count=$(ls -pL | grep -v / | wc -l)
  echo $file_count
}

determine_location () {
  cd $base_dir

  change_counter=1
  dir_changes=$(( $RANDOM % $max_depth + 1))
  cur_dir_count=$(determine_cur_dir_count)

  while [ "$change_counter" -lt "$dir_changes" ] && [ "$cur_dir_count" -gt 0 ]
  do
    let "change_counter++"
    if [ $cur_dir_count -ge 1 ]
    then
      cd $(ls -d */ | shuf -n 1)
    fi
    cur_dir_count=$(determine_cur_dir_count)
  done
}

determine_safe_location () {
  loc=$(pwd)
  if ! [[ $loc == *"$acceptable_project_name"* ]]
  then
    echo "[!] WARNING! Actions are occuring in an unsafe directory. Bailing out!"
    exit
  fi
}

gen_content () {
  max_content=500
  content_length=$(expr $RANDOM % $max_content)
  content=$(shuf -n $content_length $wordfile)
  echo $content 
}

gen_extension () {
  echo "$(shuf -n 1 $wordfile | head -c 3)"
}

gen_name () {
  max_words_in_name=3
  name_length=$(( $RANDOM % $max_words_in_name +1 ))

  name_counter=1 
  name=$(shuf -n 1 $wordfile)
  while [ $name_counter -lt $name_length ]
  do
    let "name_counter++"
    name="$name-$(shuf -n 1 $wordfile)"
  done

  echo $name
}

take_action () {
  number_possible_actions=5
  rand_action=$((($RANDOM % $number_possible_actions)+1))

  case $rand_action in
    1)
      work_action-dir_add
      ;;
    2)
      work_action-dir_rm
      ;;
    3)
      work_action-file_add
      ;;
    4)
      work_action-file_edit
      ;;
    5)
      work_action-file_rm
      ;;
  esac
}

work_action-dir_add () {
  mkdir $(gen_name)
}

#Removes a dir if there are dirs to remove, if not one is added.
work_action-dir_rm () {
  if [ $(determine_cur_dir_count) -gt 0 ]
  then
    rm -rf $(ls -d */ | shuf -n 1)
  else
    work_action-dir_add
  fi
}

work_action-file_add () {
  new_file="$(gen_name).$(gen_extension)"
  touch "$new_file"
  gen_content > $new_file
}

#Edits a file unless there are no files to add, in which case a file is added.
work_action-file_edit () {
  if [ $(determine_cur_file_count) -gt 0 ]
  then
    file_to_edit=$(ls -pL | grep -v / | shuf -n 1)
    gen_content > $file_to_edit
  else
    work_action-file_add
  fi
}

#Removes a file unless there are no files in the dir, in which case a file is added
work_action-file_rm () {
  if [ $(determine_cur_file_count) -gt 0 ]
  then
    file_to_rm=$(ls -pL | grep -v / | shuf -n 1)
    rm $file_to_rm
  else
    work_action-file_add
  fi
}

main_counter=0
while [ $main_counter -lt $number_of_actions ]
do
  let "main_counter++"

  determine_location
  determine_safe_location
  take_action
done

echo "Wow! That was rough but I am all done!"