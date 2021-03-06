# Birthday reminder
Have you ever thought about complicating birthday reminders making something very simple overly complex instead? Now you've finally found your way home!

## Usage
1. Open your terminal.

2. Run 
    ```
    $ crontab -e
    ```
    or if you want to select editor
    ```
    $ env EDITOR=nano crontab -e
    ```

3. Add something like this:
    ```
    # Format: [minute] [hour] [day of month] [month] [day of week (0=Sunday)] [command to execute]
    # Remind me of John Doe's birthday 4th of June at 08:00 that day every year
    0 8 4 6 * path/to/birthdayreminder.sh -n "John Doe" -b "1976-06-04" -u @johndoe -x https://hooks.slack.com/services/some/example/hook
    ```

## Read more
Slack web hooks - [https://api.slack.com/incoming-webhooks](https://api.slack.com/incoming-webhooks)

## Example output
![Slack message example output][example-slack-output]    

[example-slack-output]: https://github.com/partjarnberg/birthdayreminder/blob/screenshots/example-slack.png?raw=true "Example output"
[example-mail-output]: https://github.com/partjarnberg/birthdayreminder/blob/screenshots/example-mail.png?raw=true "Example output"