#!/bin/bash
yum install wget java-1.8.0-openjdk.x86_64 -y
groupadd tomcat
mkdir /opt/tomcat
useradd -s /bin/nologin -g tomcat -d /opt/tomcat tomcat
wget http://us.mirrors.quenda.co/apache/tomcat/tomcat-9/v9.0.29/bin/apache-tomcat-9.0.29.tar.gz
tar -zxvf apache-tomcat-9.0.29.tar.gz -C /opt/tomcat --strip-components=1
cd /opt/tomcat
chgrp -R tomcat conf
chmod g+rwx conf
chmod g+r conf/*
chown -R tomcat logs/ temp/ webapps/ work/
chgrp -R tomcat bin
chgrp -R tomcat lib
chmod g+rwx bin
chmod g+r bin/*
cat <<EOT >> /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat Web Application Container
After=syslog.target network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/bin/kill -15 $MAINPID

User=tomcat
Group=tomcat

[Install]
WantedBy=multi-user.target
EOT
systemctl deamon-reload
systemctl start tomcat.service
systemctl enable tomcat.service
~
~
