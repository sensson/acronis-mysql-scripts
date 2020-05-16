# Acronis MySQL

Acronis MySQL Scripts includes two backup scenarios. You can do a standard
`mysqldump` type backup before it runs but you can also do a freeze and thaw
of MySQL to create consistent backups of the raw data directory.

## Installation

```
curl -1sLf \
  'https://dl.cloudsmith.io/public/sensson/base/cfg/setup/bash.rpm.sh' \
  | sudo bash

yum install acronis-mysql-scripts
```

## Configuration

This configuration example includes both methods. You can skip whichever you
want or include both.

1. Go to cloud.acronis.com and click on the server you're backing up.
2. Click on **Backup** and select the cog-wheel on the right. This allows you
   to make changes to the existing backup plan.
3. Select **Backup options** and go to **Pre-post commands**.
4. Set the command before the backup to:
   `/var/lib/Acronis/mysqlbackup.sh`
6. We suggest to leave all default settings as they are.
7. Go to **Pre-post data capture commands**. Be sure to select the 
   **data capture** commands.
8. Set the command before data capture to:
   `/var/lib/Acronis/mysqlfreeze.sh`
9. Set the command after data capture to:
   `/var/lib/Acronis/mysqlthaw.sh`
10. We suggest to leave all default settings as they are.
11. Click **Done** and **Save changes** and apply it to the backup plan.
12. Run the backup to test if things are working.
