#!/usr/bin/env bash
source config.sh
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
    :  ) echo "Missing option argument for -$OPTARG" >&2; exit 1;;
    *  ) echo "Unimplemented option: -$OPTARG" >&2; exit 1;;
  esac
done

# Create and send email
if date -v 1d > /dev/null 2>&1; then
  # handle date as on BSD environment
  age=$(($(date -jf %s $(($(date +%s)-$(date -jf %Y-%m-%d "$birthday" +%s))) +%Y)-1970))
else
  # fallback handle date as on GNU environment
  age=$(($(date --date=@$(($(date +%s)-$(date --date="$birthday" +%s))) +%Y)-1970))
fi
mail_payload=$(<email-message-template)
mail_payload=${mail_payload/$MAIL_NAME_CONTAINER/$name}
mail_payload=${mail_payload/$MAIL_AGE_CONTAINER/$age}
echo $mail_payload | mail -s "$subject_prefix: $name" $email

# Create and send slack message
noof=$(ls -1q slack-templates/* | wc -l)
templates=(slack-templates/*.json)
slack_payload=$(<${templates[$(($RANDOM % $noof))]})
slack_payload=${slack_payload/$SLACK_USER_CONTAINER/$slack_user}
size=${#SLACK_BIRTHDAY_ICONS[@]}
while [[ $slack_payload == *"$SLACK_ICON_CONTAINER"* ]]; do
    slack_payload=${slack_payload/$SLACK_ICON_CONTAINER/${SLACK_BIRTHDAY_ICONS[$(($RANDOM % $size))]}}
done
curl -X POST --data-urlencode "payload=$slack_payload" $slack_hook_url
