#!/bin/sh
cd /Applications/Shoes.app/Contents/MacOS
APPPATH="${0%/*}"
APPFULLPATH="`cd \"$APPPATH\" && pwd`"
RUNPATH="$@"

if [ "$1" = "--ruby" ]; then
  $APPFULLPATH/shoes-bin "$@"
  exit
fi

while getopts mhv OPTION
do
  case $OPTION in
    h)  printf "Usage: shoes [options] (app.rb or app.shy)\n"
        printf "\t-m\tOpen the built-in manual.\n"
        printf "\t-v\tDisplay version info.\n"
        exit
        ;;
    m)  RUNPATH="$APPFULLPATH/command-manual.rb"
        ;;
    v)  cat "$APPFULLPATH/VERSION.txt"
        exit
        ;;
  esac
done

if [ "$1" = "" ]; then
  open -a "$APPFULLPATH/../../../Shoes.app"
else
  open -a "$APPFULLPATH/../../../Shoes.app" "$RUNPATH"
fi

cd -