#!/bin/bash
#shell install Mysql7
#[! cat /etc/profile | grep 'export PATH=$PATH:/ddhome/bin/mysql/bin' ]
cd /ddhome/bin
#tar gz
rm -rf mysql
rm -rf /ddhome/local/mysql/
tar -zxvf mysql-5.7.22-linux-glibc2.12-x86_64.tar.gz
mv mysql-5.7.22-linux-glibc2.12-x86_64 mysql
groupadd mysql
useradd -r -g mysql mysql
cd /ddhome/bin/mysql
chgrp -R mysql .
chown -R mysql .
chmod -R 755 /ddhome/
mkdir  -p /ddhome/local/mysql/data
mkdir  -p /ddhome/var/mysql/log
touch /ddhome/var/mysql/log/mariadb.log
chmod -R 755 /ddhome/bin/mysql
chmod -R 755 /ddhome/local/mysql
chmod -R 755 /ddhome/var/mysql
chown -R mysql:mysql /ddhome/bin/mysql
chown -R mysql:mysql /ddhome/local/mysql/data
chown -R mysql:mysql /ddhome/var/mysql
chown -R mysql:mysql /ddhome/local/mysql/data
#cp support-files/my-default.cnf /etc/my.cnf
cp support-files/mysql.server /etc/init.d/mysqld
chmod +x /etc/init.d/mysqld
sed -i '45d' /etc/init.d/mysqld
sed -i '46d' /etc/init.d/mysqld
sed -i '47d' /etc/init.d/mysqld
sed -i  "45a basedir=/ddhome/bin/mysql" /etc/init.d/mysqld
sed -i  "46a datadir=/ddhome/local/mysql" /etc/init.d/mysqld
chkconfig --add mysqld
chkconfig --list mysqld

cd /ddhome/bin/mysql
chgrp -R mysql .
chown -R mysql .

#sudo systemctl start mysqld
#yum install -y perl-Module-Install.noarch
#touch /ddhome/bin/mysql/mysql.pid

/ddhome/bin/mysql/bin/mysqld --defaults-file=/etc/my.cnf --initialize --user=mysql --basedir=/ddhome/bin/mysql --datadir=/ddhome/local/mysql/data
systemctl start mysqld
chown -R mysql:mysql /ddhome/local/mysql/data
chmod 755 /ddhome/local/mysql/data

#GRANT ALL PRIVILEGES ON *.* TO 'root'@'*' IDENTIFIED BY 'root' WITH GRANT OPTION;FLUSH PRIVILEGES;
#FLUSH PRIVILEGES;
/ddhome/bin/mysql/bin/mysqld_safe --skip-grant-tables & <<EOF
mysql -uroot -p
use mysql;
update user set authentication_string=password('root'),password_expired='N' where user='root';
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO root@"%" IDENTIFIED BY 'root' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

#sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent
#以上Shell脚本可以保存到一个.Shell文件里在Linux下直接运行，亲测可以正常安装，避免了一条命令一条命令的敲，这是件很让人头疼的事。
#命令说明
#1.update user set authentication_string=password('123456'),password_expired='N' where user='root';
