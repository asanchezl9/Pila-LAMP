#!/bin/bash

# 1. Actualizar los repositorios del sistema
apt-get update -y

# 2. Instalar el servidor de base de datos (MariaDB/MySQL) y Git
apt-get install -y mariadb-server git

# 3. Configurar MySQL para aceptar conexiones remotas desde la red privada
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# 4. Reiniciar el servicio para aplicar el cambio de red
systemctl restart mariadb

# 5. Descargar el código de la aplicación temporalmente para obtener el script SQL
rm -rf /tmp/iaw-practica-lamp
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git /tmp/iaw-practica-lamp

# 6. Importar el esquema de la base de datos (crea la BD 'lamp_db' y la tabla 'users')
mysql -u root < /tmp/iaw-practica-lamp/db/database.sql

# 7. Crear el usuario remoto restringido a la IP de Apache y darle permisos
mysql -u root <<< "DROP USER IF EXISTS 'lamp_user'@'192.168.56.10';"
mysql -u root <<< "CREATE USER 'lamp_user'@'192.168.56.10' IDENTIFIED BY 'lamp_password';"
mysql -u root <<< "GRANT ALL PRIVILEGES ON lamp_db.* TO 'lamp_user'@'192.168.56.10';"
mysql -u root <<< "FLUSH PRIVILEGES;"

# 8. Borrar los archivos temporales descargados
rm -rf /tmp/iaw-practica-lamp

# 9. Aislar la máquina eliminando su puerta de enlace (salida a Internet por NAT)
ip route del default