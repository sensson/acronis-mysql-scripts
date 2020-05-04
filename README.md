# Acronis MySQL

mysqlbackup.sh will create a mysqldump and stores it in /backup. At the moment
this is not configurable.

## Installation

```
curl -1sLf \
  'https://dl.cloudsmith.io/public/sensson/base/cfg/setup/bash.rpm.sh' \
  | sudo bash

yum install acronis-mysql-scripts
```

## Configuration

1. Go to cloud.acronis.com and click on the server you're backing up.
2. Click on **Backup** and select the cog-wheel on the right. This allows you
   to make changes to the existing backup plan.
3. Select **Backup options** and go to **Pre-post commands**.
4. Set the command before the backup to:
   `/var/lib/Acronis/mysqlbackup.sh`
6. We suggest to leave all default settings as they are.
7. Click **Done** and **Save changes** and apply it to the backup plan.
8. Run the backup to test if things are working.