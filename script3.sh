#!/bin/bash

while true; do
  OUTPUT=$(zenity --forms --title="Skrypt 3" --text="Znajdzmy plik:" --separator="," --add-entry="Nazwa pliku: " --add-entry="Nazwa folderu: " --add-entry="Maksymalna wielkosc: " --add-entry="Minimalna wielkosc: " --add-entry="Zawartosc: ")
  accepted=$?
  if ((accepted != 0)); then
    echo "Skrypt zakonczony!"
    exit 1
  fi
    PLIK=$(awk -F, '{print $1 ? $1 : ""}' <<<$OUTPUT)
    KATALOG=$(awk -F, '{print $2 ? $2 : "."}' <<<$OUTPUT)
    MAX_SIZE=$(awk -F, '{print $3 ? $3 : 100000000}' <<<$OUTPUT)
    MIN_SIZE=$(awk -F, '{print $4 ? $4 : 1}' <<<$OUTPUT)
    ZAWARTOSC=$(awk -F, '{print $5 ? $5 : "*"}' <<<$OUTPUT)


  if [[ $(find $KATALOG -name "$PLIK" -size +${MIN_SIZE}c -size -${MAX_SIZE}c -exec grep $ZAWARTOSC {} \;) ]]; then
    zenity --info --text "Plik istnieje!" --title "Odpowiedz"
  else
    zenity --info --text "Plik nie istnieje!" --title "Odpowiedz"
  fi
done

