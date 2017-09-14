#!/usr/bin/env bash
source config.sh
usage () { echo 'HOW TO USE:
$ birthdayreminder.sh -n <who to celebrate> -b <birthday> -u <slack username> -x <slack hook url>

EXAMPLE:
$ birthdayreminder.sh -n "John Doe" -b "1976-06-04" -u @johndoe -x https://hooks.slack.com/services/some/example/hook
'; }

while getopts ":n:b:u:x:h" option; do
  case $option in
    n  ) name="$OPTARG";;
    b  ) birthday="$OPTARG";;
    u  ) slack_user="$OPTARG";;
    x  ) slack_hook_url="$OPTARG";;
    h  ) usage; exit;;
    \? ) echo "Unknown option: -$OPTARG" >&2; exit 1;;
    :  ) echo "Missing option argument for -$OPTARG" >&2; exit 1;;
    *  ) echo "Unimplemented option: -$OPTARG" >&2; exit 1;;
  esac
done

# Calculate age
if date -v 1d > /dev/null 2>&1; then
  # handle date as on BSD environment
  age=$(($(date -jf %s $(($(date +%s)-$(date -jf %Y-%m-%d "$birthday" +%s))) +%Y)-1970))
else
  # fallback handle date as on GNU environment
  age=$(($(date --date=@$(($(date +%s)-$(date --date="$birthday" +%s))) +%Y)-1970))
fi

# Create and send slack message
noof=$(ls -1q slack-templates/* | wc -l)
templates=(slack-templates/*.json)
slack_payload=$(<${templates[$(($RANDOM % $noof))]})
# Set username
slack_payload=${slack_payload//$USER_PLACEHOLDER/$slack_user}
# Set name
slack_payload=${slack_payload//$NAME_PLACEHOLDER/$name}
# Set age
slack_payload=${slack_payload//$AGE_PLACEHOLDER/$age}
# Set unknown number of birthday icons
size=${#BIRTHDAY_ICONS[@]}
while [[ $slack_payload == *"$BIRTHDAY_ICON_PLACEHOLDER"* ]]; do
    slack_payload=${slack_payload/$BIRTHDAY_ICON_PLACEHOLDER/${BIRTHDAY_ICONS[$(($RANDOM % $size))]}}
done
# Send message payload to slack
curl -X POST --data-urlencode "payload=$slack_payload" $slack_hook_url
