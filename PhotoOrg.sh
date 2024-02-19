# Name             : PhotoOrg - photo organizer
# Author           : Tomasz Sankowski (sankowski.tomasz@gmail.com)
# Created On       : 2023/06/01 14:00
# Last Modified By : Tomasz Sankowski (sankowski.tomasz@gmail.com)
# Last Modified On : 2023/06/04 22:58
# Version          : 1.0
#
# Description      : PhotoOrg is a program that allows you to sort photos and organize them into directories in the 
#                    format year/month.
#
# Licensed under GPL (see /usr/share/common-licenses/GPL for more details
# or contact # the Free Software Foundation for a copy)

#!/bin/bash

use_date_folders=false
use_trip_folders=false

photos_taken_to_be_a_trip=20

while getopts ":dth" opt; do
  case $opt in
    d)
      use_date_folders=true
      ;;
    t)
      use_trip_folders=true
      ;;
    h)
      man ./PhotoOrg.1
      exit 0
      ;;
    \?)
      echo "Not existing option: -$OPTARG" >&2
      ;;
  esac
done

photo_dir=$(zenity --file-selection --directory --title="Choose directory with photos")
sorted_dir="$photo_dir/sorted"

declare -a months=("January" "February" "March" "April" "May" "June" "July" "August" "September" "October" "November" "December")

mkdir -p "$sorted_dir"



for file in "$photo_dir"/*; do
  if [[ -f "$file" && $(file -b --mime-type "$file") =~ ^image/ ]]; then
    timestamp=$(stat -c %Y "$file")
    year=$(date -d "@$timestamp" +"%Y")
    month=$(date -d "@$timestamp" +"%-m")
    month_name=${months[month - 1]}
    date=$(date -d "@$timestamp" +"%Y-%m-%d")
    time=$(date -d "@$timestamp" +"%H:%M:%S")

    if [ "$use_date_folders" = true ]; then
      sorted_path="$sorted_dir/$year/$month_name/$date-$time.${file##*.}"
      mkdir -p "$(dirname "$sorted_path")"
    else
      sorted_path="$sorted_dir/$date-$time.${file##*.}"
    fi

    cp "$file" "$sorted_path"
  fi
done

if [ "$use_trip_folders" = true ]; then
  for year_dir in "$sorted_dir"/*; do
    if [ -d "$year_dir" ]; then
      for month_dir in "$year_dir"/*; do
        if [ -d "$month_dir" ]; then
          month_name=$(basename "$month_dir")
          year_name=$(basename "$year_dir")
          current_day=""
          counter=0

          for file in "$month_dir"/*; do
            if [ -f "$file" ]; then
              day=$(basename "$file" | cut -d'-' -f1-3)
              if [ "$day" != "$current_day" ]; then
                if [ "$counter" -ge "$photos_taken_to_be_a_trip" ]; then
                  trip_name=$(zenity --entry --title="Name the trip" --text="Enter trip name from $current_day:")
                  if [ -n "$trip_name" ]; then
                    trip_dir="$month_dir/$trip_name"
                    mkdir -p "$trip_dir"
                    mv "$month_dir"/*"$current_day"* "$trip_dir"
                  fi
                fi
                current_day=$day
                counter=0
              fi
              counter=$((counter + 1))
            fi
          done

          if [ "$counter" -ge "$photos_taken_to_be_a_trip" ]; then
            trip_name=$(zenity --entry --title="Name the trip" --text="Enter trip name from $current_day:")
            if [ -n "$trip_name" ]; then
              trip_dir="$month_dir/$trip_name"
              mkdir -p "$trip_dir"
              mv "$month_dir"/*"$current_day"* "$trip_dir"
            fi
          fi
        fi
      done
    fi
  done
fi
