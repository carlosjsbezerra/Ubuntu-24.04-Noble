#!/bin/bash

# Variável da Data Inicial para calcular o tempo de execução do script (VARIÁVEL MELHORADA)
# opção do comando date: +%T (Time)
HORAINICIAL=$(date +%T)

# Cor verde para o texto
GREEN='\033[0;32m'
NC='\033[0m' # Sem cor

# Definindo variáveis
ZABBIX_DB="zabbix"
ZABBIX_USER="zabbix"
ZABBIX_PASSWORD="zabbix"


# Função para verificar a versão do Ubuntu
check_ubuntu_version() {
    if [ "$(lsb_release -cs)" != "noble" ]; then
        echo
        echo
	echo -e "\e[1;32mEste script é destinado apenas para Ubuntu 24.04 Noble. Saindo.\e[0m"
        exit 1
    fi
}

# Função para instalar as dependências do Zabbix Server e Agent
install_zabbix_dependencies() {
    echo 
    echo 
    echo -e "\e[1;32mInstalando as dependências do Zabbix Server e Agent...\e[0m"
    sleep 3
    echo
    echo
    
    sudo apt update 
    sudo apt install -y --install-recommends traceroute nmap snmp snmpd snmp-mibs-downloader apt-transport-https \
        software-properties-common git vim fping 
}

# Função para adicionar o repositório do Zabbix
add_zabbix_repository() {
    echo
    echo
    echo -e "\e[1;32mAdicionando o repositório do Zabbix...\e[0m"
    sleep 3
    echo
    echo 
    
    wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-6+ubuntu24.04_all.deb 
    sudo dpkg -i zabbix-release_6.0-6+ubuntu24.04_all.deb 
}

# Função para instalar o Zabbix Server, Frontend e Agent
install_zabbix() {
    echo
    echo  
    echo -e "\e[1;32mInstalando o Zabbix Server, Frontend e Agent...\e[0m"
    sleep 3
    echo
    echo 

    sudo apt update 
    sudo apt -y install --install-recommends zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf \
        zabbix-sql-scripts zabbix-agent2 zabbix-agent2-plugin-* 
    sudo apt install mysql-server -y 
}

# Verificar a versão do Ubuntu antes de começar
check_ubuntu_version

# Executar os passos de instalação
install_zabbix_dependencies
add_zabbix_repository
install_zabbix

# Criando o Banco de Dados Zabbix Server e o Usuário Zabbix
sudo mysql -u root -v <<EOF
CREATE DATABASE $ZABBIX_DB CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER '$ZABBIX_USER'@'localhost' IDENTIFIED WITH mysql_native_password BY '$ZABBIX_PASSWORD';
GRANT USAGE ON *.* TO '$ZABBIX_USER'@'localhost';
GRANT ALL PRIVILEGES ON $ZABBIX_DB.* TO '$ZABBIX_USER'@'localhost';
FLUSH PRIVILEGES;
SET GLOBAL log_bin_trust_function_creators = 1;
SHOW DATABASES;
SELECT user, host FROM mysql.user WHERE user='$ZABBIX_USER';
exit
EOF

echo
echo -e "\e[1;32mBase de dados do Zabbix Server e usuário criados com sucesso.\e[0m"
echo


echo
echo
echo -e "\e[1;32mInstalação do Zabbix Server e Agent concluída com sucesso.\e[0m"
	# script para calcular o tempo gasto (SCRIPT MELHORADO, CORRIGIDO FALHA DE HORA:MINUTO:SEGUNDOS)
	# opção do comando date: +%T (Time)
	HORAFINAL=`date +%T`
	# opção do comando date: -u (utc), -d (date), +%s (second since 1970)
	HORAINICIAL01=$(date -u -d "$HORAINICIAL" +"%s")
	HORAFINAL01=$(date -u -d "$HORAFINAL" +"%s")
	# opção do comando date: -u (utc), -d (date), 0 (string command), sec (force second), +%H (hour), %M (minute), %S (second), 
	TEMPO=`date -u -d "0 $HORAFINAL01 sec - $HORAINICIAL01 sec" +"%H:%M:%S"`
	# $0 (variável de ambiente do nome do comando)
 	echo -e "\e[1;32mTempo gasto para execução do script $0: $TEMPO\e[0m"
echo -e "Pressione <Enter> para concluir o processo."
# opção do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
echo -e "\e[1;32mFim do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\e[0m"
read
exit 1
