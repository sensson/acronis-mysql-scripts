Name:           acronis-mysql-scripts
Version:        1.0.0
Release:        1
License:        MIT
Summary:        MySQL backup scripts for Acronis

%description
Backups scripts to be used by Acronis to make backups of MySQL.

%install
mkdir -p %{buildroot}/var/lib/Acronis/
cp /srv/mysqlbackup.sh %{buildroot}/var/lib/Acronis/
cp /srv/mysql.conf %{buildroot}/var/lib/Acronis/

%files
%attr(0755, root, root) /var/lib/Acronis/mysqlbackup.sh
%attr(-, root, root) /var/lib/Acronis/mysql.conf

%config(noreplace) /var/lib/Acronis/mysql.conf
