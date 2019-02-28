#!/bin/bash
read -p "请输入要安装的包 输入编号即可，如1
1.nginx
2.mysql5.7
3.httpd
4.svn
5.ansible
6.redis
7.zabbix
8.php7.2
9.rabbitmq  " back
if [ -z $back ];then
	echo "非法值，不可为空"
	exit
elif [ $back -eq 1 ];then
		yum -y install http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
		yum -y install nginx
		/etc/init.d/nginx
		chkconfig nginx on
		sed -i "10a -A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT" /etc/sysconfig/iptables
                /etc/init.d/iptables restart

elif [ $back -eq 2 ];then
		wget https://dev.mysql.com/get/mysql57-community-release-el6-9.noarch.rpm
		yum localinstall -y mysql57-community-release-el6-9.noarch.rpm
		yum -y install mysql-community-server
		service mysqld start
		chkconfig --add mysqld
elif [ $back -eq 3 ];then
		yum -y install httpd
		chkconfig --add httpd
		sed -i "10a -A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT" /etc/sysconfig/iptables
                /etc/init.d/iptables restart
elif [ $back -eq 4 ];then
		yum -y install subversion
		chkconfig svnserver on
		sed -i "10a -A INPUT -m state --state NEW -m tcp -p tcp --dport 3690 -j ACCEPT"  /etc/sysconfig/iptables
		/etc/init.d/iptables restart
elif [ $back -eq 5 ];then
		yum -y install http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
		yum -y install ansible
		chkconfig ansible on
elif [ $back -eq 6 ];then
		wget http://mirrors.ustc.edu.cn/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
		yum -y install epel-release-6-8.noarch.rpm
		yum -y install redis
		/etc/init.d/redis
		chkconfig redis on
		sed -i "10a -A INPUT -m state --state NEW -m tcp -p tcp --dport 6379 -j ACCEPT" /etc/sysconfig/iptables
		/etc/init.d/iptables

#####安装 zabbix
elif [ $back -eq 7 ];then
		yum -y install http://repo.zabbix.com/zabbix/3.2/rhel/6/x86_64/zabbix-release-3.2-1.el6.noarch.rpm
		ip=`ifconfig | grep Bcast | awk '{print $2}' |  awk -F: '{print $2}'`
		mv /etc/zabbix/zabbix_agent.conf /etc/zabbix/zabbix_agentd.conf.bak
		sed -i "s/Server=127.0.0.1/Server=$aa/" /etc/zabbix/zabbix_agent.conf
		/etc/init.d/zabbix-agent start
		chkconfig zabbix-agent on
		sed -i "10a -A INPUT -m state --state NEW -m tcp -p tcp --dport 10050 -j ACCEPT"  /etc/sysconfig/iptables
		sed -i "10a -A INPUT -m state --state NEW -m tcp -p tcp --dport 10051 -j ACCEPT"  /etc/sysconfig/iptables
		/etc/init.d/iptables
elif [ $back -eq 8 ];then
		yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
		yum -y install http://rpms.remirepo.net/enterprise/remi-release-6.rpm
		yum -y install yum-utils
###这里安装php-7.2  也可以php-7.1 remi-php71 或者php-7.0  remi-php70
		yum-config-manager --enable remi-php72
		yum -y install php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo php-fpm
elif [ $back -eq 9 ];then
		yum -y install https://dl.bintray.com/rabbitmq/rpm/erlang/20/el/6/x86_64/erlang-20.3.8.9-1.el6.x86_64.rpm
		yum -y install epel-release
		yum install -y socat
		yum -y install http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.6/rabbitmq-server-3.6.6-1.el6.noarch.rpm
		service rabbitmq-server start
		rabbitmq-plugins enable rabbitmq_management
		rabbitmqctl add_user admin 123456
		rabbitmqctl set_user_tags admin administrator
		sed -i "10a -A INPUT -m state --state NEW -m tcp -p tcp --dport 15672 -j ACCEPT"  /etc/sysconfig/iptables
		
		
else		
	echo "请输入指定对应安装包的编号"
fi
