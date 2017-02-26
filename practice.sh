#!/bin/bash 


practice_nr=$1
RANGE=$2

entries=$(gshuf -i 1-$RANGE -n $practice_nr)
#echo "${entries[@]}"

correct=0
wrong=0

for i in $entries; do
  counter=0
  swedish=$(echo "SELECT swedish FROM wordlist WHERE ID = $i" | mysql --login-path=local swedish --skip-column-names)
  english=$(echo "SELECT english FROM wordlist WHERE ID = $i" | mysql --login-path=local swedish --skip-column-names)

  echo "Please type in the English translation of $swedish"
  read translation

  if [ "$translation" = "$english" ]; then
    echo "Good Job $USER"
    let correct=correct+1
  else
    while [ $counter -lt 3 ]; do
      echo "Not quite. Try again, $USER"
      echo "Please type in English translation of $swedish"
      read translation_new
      if [ "$translation_new" = "$english" ]; then
        echo "Good job! You guessed correctly in $((counter+2)) attempt(s)"
        counter=4
      else
        let counter=counter+1
      fi
   done
   echo "counter is $counter"
   if [ $counter -eq 4 ]; then
     let correct=correct+1
   else
     echo "You seem to not remember this word any more =("
     let wrong=wrong+1
   fi
 fi
done
./swedish.sh




