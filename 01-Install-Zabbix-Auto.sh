#!/bin/bash

# Variável da Data Inicial para calcular o tempo de execução do script (VARIÁVEL MELHORADA)
# opção do comando date: +%T (Time)
HORAINICIAL=$(date +%T)

# Definindo variáveis de cor
GREEN='\033[0;32m'
NC='\033[0m' # Sem cor

# Definindo variáveis
ZABBIX_DB="zabbix"
ZABBIX_USER="zabbix"
ZABBIX_PASSWORD="zabbix"


#01_ Função para verificar a versão do Ubuntu
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

#02_ Função para instalar o Zabbix Server, Frontend e Agent
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


#03_ Função para criar banco de dados e usuário Zabbix
create_zabbix_db_and_user() {
    echo
    echo -e "${GREEN}CRIANDO O BANCO DE DADOS ZABBIX SERVER.${NC}"
    sudo mysql -u root -v <<EOF
CREATE DATABASE $ZABBIX_DB CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
exit
EOF
    sleep 3

    echo -e "${GREEN}CRIANDO O USUÁRIO ZABBIX COM A SENHA DO BANCO DE DADOS ZABBIX.${NC}"
    sudo mysql -u root -v <<EOF
CREATE USER '$ZABBIX_USER'@'localhost' IDENTIFIED WITH mysql_native_password BY '$ZABBIX_PASSWORD';
exit
EOF
    sleep 3

    echo -e "${GREEN}CRIANDO O USUÁRIO DO BANCO DE DADOS ZABBIX SEM PERMISSÕES ESPECÍFICAS.${NC}"
    sudo mysql -u root -v <<EOF
GRANT USAGE ON *.* TO '$ZABBIX_USER'@'localhost';
exit
EOF
    sleep 3

    echo -e "${GREEN}CONCEDENDO TODAS AS PERMISSÕES AO USUÁRIO ZABBIX NO BANCO DE DADOS ZABBIX.${NC}"
    sudo mysql -u root -v <<EOF
GRANT ALL PRIVILEGES ON $ZABBIX_DB.* TO '$ZABBIX_USER'@'localhost';
exit
EOF
    sleep 3

    echo -e "${GREEN}APLICANDO AS MUDANÇAS DE PERMISSÕES NO MySQL.${NC}"
    sudo mysql -u root -v <<EOF
FLUSH PRIVILEGES;
exit
EOF
    sleep 3

    echo -e "${GREEN}HABILITANDO A CRIAÇÃO DE FUNÇÕES COM LOG_BIN_TRUST_FUNCTION_CREATORS NO MySQL.${NC}"
    sudo mysql -u root -v <<EOF
SET GLOBAL log_bin_trust_function_creators = 1;
exit
EOF
    sleep 3

    echo -e "${GREEN}LISTANDO TODOS OS BANCOS DE DADOS NO MySQL.${NC}"
    sudo mysql -u root -v <<EOF
SHOW DATABASES;
exit
EOF
    sleep 3

    echo
    echo -e "${GREEN}VERIFICANDO O USUÁRIO ZABBIX CRIADO NO BANCO DE DADOS MySQL.${NC}"
    sudo mysql -u root -v <<EOF
SELECT user, host FROM mysql.user WHERE user='$ZABBIX_USER';
exit
EOF
    sleep 3

    echo
    echo -e "\e[1;32mBase de dados do Zabbix Server e usuário criados com sucesso.\e[0m"
    echo
    sleep 3
}


#04_ Função para realizar as operações no banco de dados do Zabbix
perform_zabbix_db_operations() {
    clear
    # Populando as Tabelas no Banco de Dados do Zabbix Server utilizando o arquivo de Esquema
    echo -e "${GREEN}POPULANDO AS TABELAS NO BANCO DE DADOS DO ZABBIX SERVER.${NC}"
    sudo zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | sudo mysql --default-character-set=utf8mb4 -uzabbix -pzabbix zabbix
    sleep 3

    # Listando os Bancos de Dados do MySQL
    echo -e "${GREEN}LISTANDO OS BANCOS DE DADOS DO MySQL.${NC}"
    sudo mysql -u zabbix -p -e "SHOW DATABASES;"
    sleep 3

    # Acessando o Banco de Dados Zabbix
    echo -e "${GREEN}ACESSANDO O BANCO DE DADOS ZABBIX.${NC}"
    sudo mysql -u zabbix -p <<EOF
USE zabbix;
SHOW TABLES;
SELECT username,passwd FROM users;
exit
EOF
    sleep 3

    # Desabilitando a opção de Criação de Função no MySQL Server
    echo -e "${GREEN}DESABILITANDO A OPÇÃO DE CRIAÇÃO DE FUNÇÃO NO MySQL Server.${NC}"
    sudo mysql -u root -p <<EOF
SET GLOBAL log_bin_trust_function_creators = 0;
exit
EOF
    sleep 3

    echo
    echo -e "${GREEN}Operações concluídas.${NC}"
    echo
}


# Verificar a versão do Ubuntu antes de começar
check_ubuntu_version
# Executar os passos de instalação
install_zabbix_dependencies
#add_zabbix_repository
install_zabbix
#create database
create_zabbix_db_and_user
# Chamando a função
perform_zabbix_db_operations


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
