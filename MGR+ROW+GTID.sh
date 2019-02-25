#!/bin/bash
wget https://dev.mysql.com/get/mysql57-community-release-el6-9.noarch.rpm
yum localinstall -y mysql57-community-release-el6-9.noarch.rpm
yum -y isntall mysql-community-server
yum -y install cmake.x86_64 0:2.8.12.2-4.el6
echo "-A INPUT -m state --state NEW -m tcp -p tcp --dport 3306 -j ACCEPT" >> /etc/sysconfig/iptables
echo "-A INPUT -m state --state NEW -m tcp -p tcp --dport 33061 -j ACCEPT" >> /etc/sysconfig/iptables


