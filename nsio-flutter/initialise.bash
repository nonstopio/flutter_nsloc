#!/bin/bash

while getopts ":o:n:" opt; do
  case $opt in
    o) org="$OPTARG"
    ;;
    n) name="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2 ; exit 1
    ;;
  esac
done

if [ -z "$name" ] || [ -z "$org" ]; then
    echo "-o (organization name) and -n (name of project) is requried"
    exit 1
fi


rm -rf android/ ios/ .git/

echo "creating $name for $org"

flutter create --org $org --project-name $name -a java .
flutter packages get

echo "Saving your time... Take a deep breath.. You are about to change the world.."

find . |while read fname; do
  if [ -f "$fname" ]; then
    sed -i "s/nsio_flutter/$name/g" "$fname"
  fi
done

git init
cp git_hooks/pre-commit .git/hooks/pre-commit
rm ./initialise.bash
