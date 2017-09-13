#!/usr/bin/env bash


usage () { echo 'HOW TO USE:
$ birthdayreminder.sh -n <who to celebrate> -b <birthday> -e <email to notify about age> -s <email subject prefix> -u <slack username> -x <slack hook url>

EXAMPLE:
$ birthdayreminder.sh -n "John Doe" -b "1976-06-04" -e jane.roe@example.com -s "BIRTHDAY REMINDER" -u @johndoe -x https://hooks.slack.com/services/some/example/hook
'; }

while getopts ":s:b:n:e:u:x:h" option; do
  case $option in
    n  ) name="$OPTARG";;
    b  ) birthday="$OPTARG";;
    e  ) email="$OPTARG";;
    s  ) subject_prefix="$OPTARG";;
    u  ) slack_user="$OPTARG";;
    x  ) slack_hook_url="$OPTARG";;
    h  ) usage; exit;;
    \? ) echo "Unknown option: -$OPTARG" >&2; exit 1;;
    : ) echo "Missing option argument for -$OPTARG" >&2; exit 1;;
    *  ) echo "Unimplemented option: -$OPTARG" >&2; exit 1;;
  esac
done

age=$(($(date -jf %s $((`date +%s` - `date -jf %Y-%m-%d "$birthday" +%s`)) +%Y)-1970))

echo "Congratulate $name who turns $age today" | mail -s "$subject_prefix: $name" $email

birthday_icons=(":birthday:" ":sparkles:" ":tada:" ":champagne:" ":cake:" \
":star2:" ":star:" ":cocktail:" ":tropical_drink:" ":dizzy:")
size=${#birthday_icons[@]}

payload="{\"username\": \"Polluxian\", \"text\": \"Pssst! Idag är det en speciell dag. Det är $slack_user 's födelsedag! Hurra! ${birthday_icons[$(($RANDOM % $size))]} \
${birthday_icons[$(($RANDOM % $size))]} ${birthday_icons[$(($RANDOM % $size))]}\", \"icon_emoji\": \":alien:\"}"

echo $payload

curl -X POST --data-urlencode "payload=$payload" $slack_hook_url
