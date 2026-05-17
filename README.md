# Acronis MySQL

Acronis MySQL Scripts includes two backup scenarios. You can do a standard
`mysqldump` type backup before it runs but you can also do a freeze and thaw
of MySQL to create consistent backups of the raw data directory.

## Installation

The following command will install the Sensson OSS-repository.

```bash
$ curl -1sLf \
  'https://dl.cloudsmith.io/public/sensson/base/cfg/setup/bash.rpm.sh' \
  | sudo bash
```

Or on Ubuntu.

```bash
curl -1sLf \
  'https://dl.cloudsmith.io/public/sensson/base/setup.deb.sh' \
  | sudo -E bash
```

Once the Sensson OSS-repository is available you can use `yum` or `apt` 
to install these scripts and keep them up to date.

```
# Redhat/CentOS
$ sudo yum install acronis-mysql-scripts

# Ubuntu
$ sudo apt update && apt install acronis-mysql-scripts
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

## Remote backups

By default these scripts back up MySQL on the same server. If you also want
to back up a single remote MySQL server from this machine, an additional
script is provided: `/var/lib/Acronis/mysqlbackup-remote.sh`. It is opt-in
and is not used unless you configure and invoke it explicitly.

1. Create a credentials file for the remote server, e.g.
   `/root/.my-remote.cnf`:

   ```ini
   [client]
   host = db2.example.com
   user = backup
   password = your-password-here
   ```

   Make sure it is only readable by root: `chmod 600 /root/.my-remote.cnf`.

2. Edit `/var/lib/Acronis/mysql-remote.conf` to point at the credentials
   file and pick a separate backup location, for example:

   ```
   extra_file = /root/.my-remote.cnf
   backup_location = /backup/remote
   local_retention = 2
   ```

3. Acronis only supports a single pre-backup command. Pick the one that
   matches what you want to back up:

   - Local only: `/var/lib/Acronis/mysqlbackup.sh`
   - Remote only: `/var/lib/Acronis/mysqlbackup-remote.sh`
   - Both: `/var/lib/Acronis/mysqlbackup-all.sh`

   The combined script runs both backups independently, so a failure in
   one does not block the other. The remote script only performs a
   `mysqldump` — freeze and thaw remain local-only.

## Limitations

These scripts have been tested on:

- CentOS 7 and 8.
- Ubuntu 22.04 and 24.04.

## Tests

Sorry, this code doesn't come with tests yet.

## Development

We strongly believe in the power of open source. This module is our way of
saying thanks.

If you want to contribute please:

1. Fork the repository.
2. Push to your fork and submit a pull request to the develop branch.
