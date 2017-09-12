#!/usr/bin/env bash

while getopts ":s:b:n:e:u:x:" opt; do
  case $opt in
    s) subject_prefix="$OPTARG"
    ;;
    b) birthday="$OPTARG"
    ;;
    n) name="$OPTARG"
    ;;
    e) email="$OPTARG"
    ;;
    u) user="$OPTARG"
    ;;
    x) slack_hook_url="$OPTARG"
    ;;
  esac
done

age=$(($(date -jf %s $((`date +%s` - `date -jf %Y-%m-%d "$birthday" +%s`)) +%Y)-1970))

echo "Congratulate $name who turns $age today" | mail -s "$subject_prefix: $name" $email

birthday_icons=(":birthday:" ":sparkles:" ":tada:" ":champagne:" ":cake:" \
":star2:" ":star:" ":cocktail:" ":tropical_drink:" ":dizzy:")
size=${#birthday_icons[@]}

payload="{\"username\": \"Polluxian\", \"text\": \"Pssst! Idag är det en speciell dag. Det är $user 's födelsedag! Hurra! ${birthday_icons[$(($RANDOM % $size))]} \
${birthday_icons[$(($RANDOM % $size))]} ${birthday_icons[$(($RANDOM % $size))]}\", \"icon_emoji\": \":alien:\"}"

echo $payload

curl -X POST --data-urlencode "payload=$payload" $slack_hook_url
