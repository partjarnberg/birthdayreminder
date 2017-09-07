#!/usr/bin/env bash

while getopts ":s:b:n:e:" opt; do
  case $opt in
    s) subject_prefix="$OPTARG"
    ;;
    b) birthday="$OPTARG"
    ;;
    n) name="$OPTARG"
    ;;
    e) email="$OPTARG"
    ;;
  esac
done

age="$(python birthdaycalc.py "$name" $birthday)"

echo "Congratulate $name who turns $age today" | mail -s "$subject_prefix: $name" $email
