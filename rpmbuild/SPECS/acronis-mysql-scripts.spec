Name:           acronis-mysql-scripts
Version:        ##version##
Release:        1
License:        MIT
Summary:        MySQL backup scripts for Acronis

%description
Backups scripts to be used by Acronis to make backups of MySQL.

%install
mkdir -p %{buildroot}/var/lib/Acronis/
cp /srv/mysqlbackup.sh %{buildroot}/var/lib/Acronis/
cp /srv/mysqlbackup-remote.sh %{buildroot}/var/lib/Acronis/
cp /srv/mysqlbackup-all.sh %{buildroot}/var/lib/Acronis/
cp /srv/mysqlfreeze.sh %{buildroot}/var/lib/Acronis/
cp /srv/mysqlthaw.sh %{buildroot}/var/lib/Acronis/
cp /srv/mysql.conf %{buildroot}/var/lib/Acronis/
cp /srv/mysql-remote.conf %{buildroot}/var/lib/Acronis/
cp /srv/functions.sh %{buildroot}/var/lib/Acronis/

%files
%attr(0755, root, root) /var/lib/Acronis/mysqlbackup.sh
%attr(0755, root, root) /var/lib/Acronis/mysqlbackup-remote.sh
%attr(0755, root, root) /var/lib/Acronis/mysqlbackup-all.sh
%attr(0755, root, root) /var/lib/Acronis/mysqlfreeze.sh
%attr(0755, root, root) /var/lib/Acronis/mysqlthaw.sh
%attr(-, root, root) /var/lib/Acronis/mysql.conf
%attr(-, root, root) /var/lib/Acronis/mysql-remote.conf
%attr(-, root, root) /var/lib/Acronis/functions.sh

%config(noreplace) /var/lib/Acronis/mysql.conf
%config(noreplace) /var/lib/Acronis/mysql-remote.conf
