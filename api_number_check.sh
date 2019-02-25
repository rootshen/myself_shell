#!/bin/bash
#此脚本用途为 收集API（10.11.12）;PM(87)接口日志    
#此脚本需使用ansible 否则执行报错 ansible 192.168.1.99 script -m api_number_check.sh
if [ ! -d /mnt/log_file ];then
mkdir /mnt/log_file
fi
if [ ! -d /mnt/log ];then
mkdir /mnt/log
fi
if [ ! -d /mnt/log_analyze ];then
mkdir /mnt/log_analyze
fi

for i in {1..7}
	do
	d1=`date -d "$i days ago" +%Y%m%d`
	dd=access.log-`date -d "$i days ago" +%Y%m%d`.gz
	echo > /mnt/log/time.txt
	for d in {10..12}
		do
		scp 192.168.1.$d:/var/log/nginx/$dd /mnt/log_file > /dev/null
		gzip -cd /mnt/log_file/$dd > /mnt/log/log_gzip.txt
        	rm -rf /mnt/log_file/*
		cat /mnt/log/log_gzip.txt | awk '{print $NF}' | sort -u |sort -n -k 1 -r | awk -F'"' '{print $2}' > /mnt/log/API.txt
		for i in `cat /mnt/log/API.txt`
			do
			grep "$i" /mnt/log/log_gzip.txt | awk '{print substr($4,14,2),$NF}'| awk '{print $2,$1}' | sort >> /mnt/log/time.txt
		done
	done
	echo "${d1}" > /mnt/log_analyze/API-${d1}.csv  
	awk -F'"' '{print $3,$2}' /mnt/log/time.txt | awk 'gsub(/^ *| *$/,"")' | sort | uniq -c | awk '{print $3","$2","$1}' | sort >> /mnt/log_analyze/API-${d1}.csv
done
echo -e "\033[32m 服务器10，11，12日志整理结束 前往99:/mnt/log_analyze 下自行提取 \033[0m"
for i in {1..7}
        do
        d1=`date -d "$i days ago" +%Y%m%d`
        dd=access.log-`date -d "$i days ago" +%Y%m%d`.gz
        echo > /mnt/log/time.txt
	scp 192.168.1.87:/var/log/nginx/$dd /mnt/log_file > /dev/null
	gzip -cd /mnt/log_file/$dd > /mnt/log/log_gzip.txt
        rm -rf /mnt/log_file/*
        cat /mnt/log/log_gzip.txt | awk '{print $NF}' | sort -u |sort -n -k 1 -r | awk -F'"' '{print $2}' > /mnt/log/API.txt
	for i in `cat /mnt/log/API.txt`
        	do
        	grep "$i" /mnt/log/log_gzip.txt | awk '{print substr($4,14,2),$NF}'| awk '{print $2,$1}' | sort >> /mnt/log/time.txt
	done
	echo "${d1}" > /mnt/log_analyze/PM-${d1}.csv  
	awk -F'"' '{print $3,$2}' /mnt/log/time.txt | awk 'gsub(/^ *| *$/,"")' | sort | uniq -c | awk '{print $3","$2","$1}' |sort >> /mnt/log_analyze/PM-${d1}.csv
done
echo -e "\033[32m 服务器87 pm日志整理结束 前往99:/mnt/log_analyze 下自行提取  \033[0m"
rm -rf /mnt/log_file
rm -rf /mnt/log
