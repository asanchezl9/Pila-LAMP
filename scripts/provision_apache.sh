#!/bin/bash

# 1. Actualizar los repositorios del sistema
apt-get update -y

# 2. Instalar Apache, el intérprete PHP, los módulos necesarios y Git
apt-get install -y apache2 php libapache2-mod-php php-mysql git

# 3. Clonar el repositorio de la aplicación temporalmente
rm -rf /tmp/iaw-practica-lamp
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git /tmp/iaw-practica-lamp

# 4. Vaciar el directorio web por defecto y mover el código fuente de la app (carpeta src)
rm -rf /var/www/html/*
mv /tmp/iaw-practica-lamp/src/* /var/www/html/

# 5. Configurar la conexión a la base de datos en config.php
sed -i "s/'localhost'/'192.168.56.11'/" /var/www/html/config.php
sed -i "s/'database_name_here'/'lamp_db'/" /var/www/html/config.php
sed -i "s/'username_here'/'lamp_user'/" /var/www/html/config.php
sed -i "s/'password_here'/'lamp_password'/" /var/www/html/config.php

# 6. Asignar los permisos correctos al usuario de Apache
chown -R www-data:www-data /var/www/html

# 7. Borrar archivos temporales y reiniciar Apache
rm -rf /tmp/iaw-practica-lamp
systemctl restart apache2