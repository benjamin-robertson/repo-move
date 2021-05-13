#!/bin/bash
#
# Usage:
# See syntax of repolist
# Include repo to move in this file. By default script will look for repolist, other specify a argment for repo to move
# EG, ./move-repo.sh /path/to/repolist
#
firstarg=$1

# Set repolist location
if [[ $firstarg == "" ]]
then
  repolist="./repolist"
else
  repolist=$firstarg
fi

# Get length of repolist
length=`wc $repolist | awk '{ print $1 }'`
length=$(($length - 1))

count=0
repos=()

for i in `tail -n $length $repolist`
do
  repos+=( $i )
  count=$(($count + 1))
done


for ((x=0;x < $count; x=$x + 2)); do
  x2=$(($x + 1))
  echo "Cloning repo ${repos[$x]} to ${repos[$x2]}"

  git clone --mirror ${repos[$x]}
  # get filename
  folder=`echo ${repos[$x]} | awk -F "/" '{ print $2 }' | sed 's/.git//g'`
  cd $folder

  #change the remote git server and push
  git remote add mirror ${repos[$x2]}
  git push --all --prune mirror
  git push --tags --prune mirror
  cd ..
done
