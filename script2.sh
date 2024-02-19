#!/bin/bash

echo "1. Nazwa:"
echo "2. Katalog:"
echo "3. Wieksze niz:"
echo "4. Mniejsze niz:"
echo "5. Zawartosc:"
echo "6. Szukaj:"
echo "7. Koniec:"
read INPUT
PLIK=""
KATALOG="."
WIELKOSC_MIN=1
WIELKOSC_MAX=1000000
ZAWARTOSC=*
while [ $INPUT -ne 7 ];do
case $INPUT in


"1")
echo "Podaj nazwe pliku:"
read PLIK
;;

"2")
echo "Podaj nazwe katalogu:"
read KATALOG
;;


"3")
echo "Podaj minimalny rozmiar pliku pliku:"
read WIELKOSC_MIN
;;


"4")
echo "Podaj maksymalny rozmiar pliku:"
read WIELKOSC_MAX
;;


"5")
echo "Podaj zawartosc pliku:"
read ZAWARTOSC
;;

"6")
if [[ $(find $KATALOG -name "$PLIK" -size +${WIELKOSC_MIN}c -size -${WIELKOSC_MAX}c -exec grep $ZAWARTOSC {} \;) ]]; then
echo "1. Nazwa: ${PLIK}"
echo "2. Katalog: ${KATALOG}"
echo "3. Wieksze niz: ${WIELKOSC_MIN}"
echo "4. Mniejsze niz: ${WIELKOSC_MAX}"
echo "5. Zawartosc: ${ZAWARTOSC}"
echo "6. Szukaj: Plik istnieje!"
echo "7. Koniec:"
else
echo "1. Nazwa: ${PLIK}"
echo "2. Katalog: ${KATALOG}"
echo "3. Wieksze niz: ${WIELKOSC_MIN}"
echo "4. Mniejsze niz: ${WIELKOSC_MAX}"
echo "5. Zawartosc: ${ZAWARTOSC}"
echo "6. Szukaj: Plik nie istnieje!"
echo "7. Koniec:"
fi
echo "/////////////////////////////////////////////////////////////////"
PLIK=""
KATALOG="."
WIELKOSC_MIN=1
WIELKOSC_MAX=1000000
ZAWARTOSC=*
;;

*) echo "Nie znam komendy"
;;
esac
echo "1. Nazwa: ${PLIK}"
echo "2. Katalog: ${KATALOG}"
echo "3. Wieksze niz: ${WIELKOSC_MIN}"
echo "4. Mniejsze niz: ${WIELKOSC_MAX}"
echo "5. Zawartosc: ${ZAWARTOSC}"
echo "6. Szukaj:"
echo "7. Koniec:"
read INPUT
done
echo "Koniec programu!"
