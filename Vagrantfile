Vagrant.configure("2") do |config|
  # Imagen base para ambas máquinas: Debian 12 (Bookworm)
  config.vm.box = "debian/bookworm64"

  # =========================================================
  # NIVEL 1 (Front-end): Servidor Web Apache + PHP
  # =========================================================
  config.vm.define "AmparoApache" do |apache|
    apache.vm.hostname = "AmparoApache"
    
    # Red privada para comunicarse internamente con MySQL
    apache.vm.network "private_network", ip: "192.168.56.10"
    
    # Port Forwarding: conecta el puerto 8080 de nuestra máquina real con el 80 de la VM
    apache.vm.network "forwarded_port", guest: 80, host: 8080
    
    # Script de aprovisionamiento para instalar Apache, PHP y la App
    apache.vm.provision "shell", path: "scripts/provision_apache.sh"
  end

  # =========================================================
  # NIVEL 2 (Back-end): Servidor de Base de Datos MySQL
  # =========================================================
  config.vm.define "AmparoMysql" do |mysql|
    mysql.vm.hostname = "AmparoMysql"
    
    # Red privada en el mismo rango que Apache
    mysql.vm.network "private_network", ip: "192.168.56.11"
    
    # Script de aprovisionamiento para instalar MySQL, la BD y aislar de Internet
    mysql.vm.provision "shell", path: "scripts/provision_mysql.sh"
  end
end