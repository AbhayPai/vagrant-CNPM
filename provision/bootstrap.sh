#!/usr/bin/env bash
installUpdate() {
  echo ">> updating packages <<"
    sudo  yum -y update >/dev/null
}

installEPEL() {
  echo ">> downloading and installing EPEL <<"
    sudo yum -y install epel-release >/dev/null
}

installRPM() {
  echo ">> dowloading rpm <<"
    sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm >/dev/null
}

installNginx() {
  installUpdate;

  installEPEL;

	echo ">> downloading nginx <<"
	  sudo yum -y install nginx >/dev/null

	echo ">> enabling nginx <<"
	  sudo systemctl enable nginx >/dev/null

	echo ">> restarting nginx <<"
	  sudo systemctl restart nginx >/dev/null

  echo ">> nginx version <<"
    sudo nginx -v >/dev/null
}

installPHP7() {
  installEPEL;

  installRPM;

  echo ">> download and installing php <<"
    yum install -y php72w-fpm php72w-cli php72w-common php72w-dba php72w-devel php72w-embedded php72w-enchant php72w-gd  php72w-imap  php72w-interbase php72w-intl php72w-ldap php72w-mbstring php72w-mysql  php72w-odbc php72w-opcache php72w-pdo php72w-pdo_dblib php72w-pear php72w-pecl-apcu php72w-pecl-imagick php72w-pecl-mongodb php72w-pgsql php72w-phpdbg php72w-process php72w-pspell php72w-recode php72w-snmp php72w-soap php72w-sodium php72w-tidy php72w-xml php72w-xmlrpc >/dev/null

  echo ">> restarting nginx <<"
    sudo systemctl restart nginx >/dev/null

  echo ">> php version <<"
    sudo php -v
}

installMariaDB() {
  echo ">> download and installing mariabdb <<"
    sudo yum -y install mariadb-server mariadb >/dev/null

  echo ">> starting mariabdb <<"
    sudo systemctl start mariadb >/dev/null

  echo ">> configuring mariadb on startup <<"
    sudo systemctl enable mariadb >/dev/null

  echo ">> configuring mariadb on startup <<"
    sudo mysql --version
}

installNodeNPM() {
  echo ">> dowloading and installing NPM for nodejs <<"
    sudo yum install -y npm >/dev/null

  echo ">> NPM version <<"
    sudo npm --version
}

installNodeJS() {
  installEPEL;

  echo ">> downloading and installing nodejs <<"
    sudo yum install -y nodejs >/dev/null

  echo ">> nodejs version <<"
    sudo node --version

  installNodeNPM;
}

configureStackInfo() {
  echo ">> configuring stack info project <<"
    sudo cp /var/www/html/projects/configuration/guestconfig/* /etc/nginx/conf.d

  echo ">> setting SELinux to permissive <<"
    sudo setenforce 0

  echo ">> restarting nginx <<"
    sudo systemctl restart nginx >/dev/null

  echo ">> restarting php <<"
    sudo systemctl restart php-fpm >/dev/null
}

configureWebpackStack() {
  echo ">> creating node modules directroy in ~ <<"
    mkdir /home/vagrant/node_modules

  echo ">> creating symbolic link for ~/node_modules with /var/www/html/projects/webpack-app1/frontend"
    ln -sf /home/vagrant/node_modules/ /var/www/html/projects/webpack-app1/frontend
}

installNginx;

installPHP7;

installMariaDB;

installNodeJS;

configureStackInfo;

configureWebpackStack;
