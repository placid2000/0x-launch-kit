#!/usr/bin/env bash

echo "Updating Packages"
apt-get update

echo "Setting timezone"
timedatectl set-timezone Europe/Zurich

echo "Installing MySQL"
debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'
apt-get install -y mysql-client mysql-server

echo "Disabling host-binding in MySql"
sed -i 's/bind-address/#bind-address/' /etc/mysql/my.cnf
service mysql restart

echo "Disabling new sql-modes of MySql 5.7"
echo 'sql-mode = "TRADITIONAL"' >> /etc/mysql/mysql.conf.d/mysqld.cnf

echo "Creating MySql User and granting privileges"
mysql -uroot -ppassword -e"GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION;"
service mysql restart

sudo apt-get install git
sudo apt-get install unzip

echo "Installing NodeJS NPM and Gulp"
sudo apt-get install -y nodejs
sudo apt-get install -y npm

sudo ln -s /usr/bin/nodejs /usr/bin/node

echo "Installing phpmyadmin"
add-apt-repository ppa:nijel/phpmyadmin
apt-get update
debconf-set-selections <<< 'phpmyadmin phpmyadmin/dbconfig-install boolean true'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/app-password-confirm password password'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-pass password password'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/app-pass password password'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2'
apt-get install -y phpmyadmin
echo 'Include /etc/phpmyadmin/apache.conf' >> /etc/apache2/apache2.conf

echo "Installing composer"
php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php
sudo php composer-setup.php --filename=composer --install-dir=/bin
rm composer-setup.php

echo "Configuring fvs project"
echo "127.0.0.1 relayer.lo" >> /etc/hosts

echo "Autoremove"
apt-get autoremove -y
echo "cd /vagrant" >> /home/vagrant/.profile