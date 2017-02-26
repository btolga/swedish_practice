#!/bin/bash

echo -e "Let's learn a new Swedish word \n\nWould you like to: \nA. Type in English the word you want to learn \nB. Randomly choose a word \nC. Go Back \nD. Quit"
read choice

if [[ $choice =~ ^[Aa]$ ]] || [[ $choice =~ ^[Aa][[:punct:]]$ ]]; then
  echo "Type in English the word you want to learn"
  read word
  contains=$(echo "SELECT COUNT(1) FROM wordlist WHERE english = '$word'" | mysql --login-path=local swedish --skip-column-names)
  swedish=$(echo "SELECT swedish FROM wordlist WHERE english= '$word'" | mysql --login-path=local swedish --skip-column-names)
  if [[ $contains -eq 1 ]]; then
    echo "This word is already in the list of words you know. It means $swedish"
    ./new_word.sh 
  else
    echo 'get word in Swedish'
    swedish_new=($(python3 get_word.py "a" "$word" 2>&1 | tr -d '[],'))
    #swedish_new=$(python get_word.py "a" "$word" 2>&1)
    if [[ $swedish_new = '' ]]; then
      echo "This is not a proper English word. Please type in a proper word"
      ./new_word.sh 
    else
      echo -e "${swedish_new[*]} \n"
    #echo -e "$swedish_new"
      echo "Do you want to add this word to your Ordbok? [y/n]"
      read answer

      if [[ $answer =~ ^[Yy]  ]]; then
        echo "Which meaning do you want to add? 1-${#swedish_new[*]}"
        read number
        let "number=number-1"
        query=" INSERT INTO wordlist (swedish, english) VALUES (${swedish_new[$number]} , '$word' )"
        echo $query | mysql --login-path=local Swedish
        echo "word successfully added to the Ordbok"
        ./swedish.sh
      else
        ./new_word.sh
      fi
    fi
  fi
elif [[ $choice =~ ^[Bb]$ ]] || [[ $choice =~ ^[Bb][[:punct:]]$ ]]; then
  echo 'get a random Swedish word'
  all=($(python3 get_word.py "b" "random" 2>&1 | tr -d '[],'))
  #echo "all array is ${all[*]}"
  echo "Your random word is ${all[${#all[*]}-1]}"
  eng=${all[${#all[*]}-1]}
  unset 'all[${#all[@]}-1]'
  #for a in "${all[*]}"; do echo "$a"; done

  echo -e "The swedish translations are: \n${all[*]} \n"
  echo "Do you want to add this word to your Ordbok? [y/n]"
  read answer
  
  if [[ $answer =~ ^[Yy] ]]; then
    echo "Which meaning do you want to add? 1-${#all[@]}"
    read number
    let "number=number-1"
    query=" INSERT INTO wordlist (swedish, english) VALUES (${all[$number]} , $eng )"
    echo $query
    echo $query | mysql --login-path=local Swedish
    echo "word successfully added to the Ordbok"
    ./swedish.sh 
  else
    ./new_word.sh
  fi
 




elif [[ $choice =~ ^[Cc]$ ]] || [[ $choice =~ ^[Cc][[:punct:]]$ ]]; then
  ./swedish.sh 
elif [[ $choice =~ ^[Dd]$ ]] || [[ $choice =~ ^[Dd][[:punct:]]$ ]]; then
  exit
else
  echo 'Choose A, B, C, or D'
  ./new_word.sh
fi

