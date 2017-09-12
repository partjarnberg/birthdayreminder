# Birthday reminder
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
    # Remind me of someones birthday at 10th of June at 07:00 every year
    0 7 10 6 * path/to/birthdayreminder.sh -n "Some name" -b "1970-06-10" -e my.mail@example.com -s "Subject prefix" -u @[slack user of the celebrated] -x [slack hook url]
    ```

4. Example output
![Slack message example output][example-output]    


[example-output]: https://github.com/partjarnberg/birthdayreminder/blob/screenshots/example.png?raw=true "Example output"