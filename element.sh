#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
  then
  # If there is no argument
  echo "Please provide an element as an argument."
  else
  # search into the database 
    # if it is a number
    if [[ $1 =~ ^[0-9]+$ ]]
    then
    ASK_NUMBER=$($PSQL "SELECT atomic_number,symbol,name FROM elements WHERE atomic_number=$1")
    else
    # if it is not a number
    ASK_SYMBOL=$($PSQL "SELECT atomic_number,symbol,name FROM elements WHERE symbol='$1'")
    ASK_NAME=$($PSQL "SELECT atomic_number,symbol,name FROM elements WHERE name='$1'")
    fi 
  
  # look if it exists
  if [[ $ASK_NUMBER ]]
    then
    # if the number exists into the database
    READ_ELEMENT=$ASK_NUMBER
    else 
    # if the symbol exists into the database
    if [[ $ASK_SYMBOL ]]
      then 
      READ_ELEMENT=$ASK_SYMBOL
      else
        # if the name exists into the database
        if [[ $ASK_NAME ]]
          then 
          READ_ELEMENT=$ASK_NAME
          else 
          echo "I could not find that element in the database."
        fi
    fi
  fi
  
  # If it exists into the database, search about number,symbol,name
  if [[ $READ_ELEMENT ]]
  then
  echo $READ_ELEMENT | while IFS="|" read NUMBER SYMBOL NAME
  do
    READ_PROPERTIES=$($PSQL "SELECT atomic_number,types.type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM properties full join types on properties.type_id=types.type_id WHERE atomic_number=$NUMBER;")
    echo $READ_PROPERTIES | while IFS="|" read NUMBER TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
    do
    echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
  done
  fi

fi
