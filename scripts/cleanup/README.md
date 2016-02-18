Places Cleanup Scripts
==========================
These scripts fix issues with rendering, then need to be run periodically
TODO: Add these to a cron task

fix_missing_elements.sql
------------------------
* This script will find any elements that haven't been rendered for whatever reason, and it will render them
* This runs relatively quickly because it is greedy on selecting what records are missing
* This also means that there will always be records that it tries to render

fix_missing_versions.sql
-------------------------
* This looks for rendered objects that have the wrong version
* It then re-renders then with the right version

update_tags.sql
---------------
* Run this every time tags get changed
* This will go through the database and find anything that has been rendered with the wrong tags and will update them
* __ALERT__: This query may take up to an hour to run!
