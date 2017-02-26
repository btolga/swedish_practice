#!/bin/bash

#problem is the number changes so need to check equality before the numbers
stat=$(mysql.server status)

if [[ "${stat:1:1}" = "E" ]]; then
  mysql.server start
fi
echo -e "\nHello $USER, let's practice our Svenska!\n"
echo -e "Would you like to:"
A="A. Practice words you know"
echo -e "$A"
B="B. Learn new words"
echo -e "$B"
C="C. Quit"
echo -e "$C \n"

read choice

if [ $choice = "A" ] || [ $choice = "A." ] || [ $choice = "a"  ] || [ $choice = "a."  ]; then
  echo "You chose $A"
  known_words=$(echo "SELECT COUNT(1) FROM wordlist" | mysql --login-path=local --skip-column-names swedish)
  echo "Currently, you know $known_words words"
  echo "How many words would you like to practice today?"
  read practice_nr
  ./practice.sh $practice_nr $known_words

elif [ $choice = "B" ] || [ $choice = "B." ] || [ $choice = "b."  ] || [ $choice = "b"  ]; then
  echo "You chose $B"
  ./new_word.sh
elif [ $choice = "C"  ] || [ $choice = "C."  ] || [ $choice = "c."   ] || [ $choice = "c"   ]; then
  echo "Bye, $(whoami)!"
  exit
else
  echo -e "You should choose either A. or B.\n"
  ./swedish.sh
fi
