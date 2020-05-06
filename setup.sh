if ! [[ "${USER:-}" == "root" ]]
then
  echo "Please run as root" >&2
  exit 1
fi

yes Y | sudo apt update
yes Y | sudo apt install mysql-server mysql-client

    if ! sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'secret123';"; then
        echo "\033[93mSeems you already have mysql password created on this machine, please provide below to continue\033[0m \n"
        read input_variable
        sudo mysql -u 'root' "-p$input_variable" -e "CREATE USER web_service identified by '$input_variable'"
        sudo mysql -u 'root' "-p$input_variable" -e "REVOKE ALL PRIVILEGES ON *.* FROM 'web_service'@'%'; GRANT ALL PRIVILEGES ON *.* TO 'web_service'@'%' REQUIRE NONE WITH GRANT OPTION MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;"
    else
        sudo mysql -u 'root' '-psecret123' -e "CREATE USER web_service identified by 'secret123'"
        sudo mysql -u 'root' '-psecret123' -e "grant all on `web_service\_%`.* to `web_service`@`%`;"
    fi

yes Y | sudo apt install apache2

'<IfModule mod_dir.c>
    DirectoryIndex index.html index.php index.xhtml index.htm
</IfModule>' >> /etc/apache2/mods-enabled/dir.conf


'<VirtualHost *:80>
     ServerAdmin webmaster@localhost
     DocumentRoot /var/www/html/

     ErrorLog ${APACHE_LOG_DIR}/error.log
     CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>' >> /etc/apache2/sites-enabled/000-default.conf

yes Y | sudo systemctl restart apache2.service

yes Y | sudo apt-get install php php-cgi libapache2-mod-php php-common php-pear php-mbstring
yes Y | sudo a2enconf php7.2-cgi
yes Y | sudo systemctl reload apache2.service


yes Y | sudo apt-get install phpmyadmin php-gettext

echo "\033[93mDo you want to open your database to remote connections? (Y/N) \033[0m \n"
read input_response

if [[ "$input_response" == "Y" ]]; then
    echo -e "Continuing..."
    sudo curl https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip -o ngrok.zip && unzip ./ngrok.zip && rm ngrok.zip
    sudo ./ngrok authtoken 1bERy5v8oy4MUkCgoz5M4nsS7Ue_7ThbyJChnrNi8verBAhiq
    sudo ./ngrok http 80
  else
    echo -e "Exiting..."
    exit 1
  fi
