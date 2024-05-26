#!/bin/bash

# Função para verificar a versão do Ubuntu
check_ubuntu_version() {
    if [ "$(lsb_release -cs)" != "noble" ]; then
	echo "Este script é destinado apenas para Ubuntu 24.04 Noble. Saindo."
        exit 1
    fi
}

# Função para instalar as dependências do Zabbix Server e Agent
install_zabbix_dependencies() {
    echo
    echo
    echo "Instalando as dependências do Zabbix Server e Agent..."
    echo
    read -p "Pressione Enter para continuar..."
    echo
    
    sudo apt update
    sudo apt install --install-recommends traceroute nmap snmp snmpd snmp-mibs-downloader apt-transport-https \
        software-properties-common git vim fping
}

# Função para adicionar o repositório do Zabbix
add_zabbix_repository() {
    echo
    echo "Adicionando o repositório do Zabbix..."
    read -p "Pressione Enter para continuar..."
    echo
    
    wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-6+ubuntu24.04_all.deb
    sudo dpkg -i zabbix-release_6.0-6+ubuntu24.04_all.deb
}

# Função para instalar o Zabbix Server, Frontend e Agent
install_zabbix() {
    echo
    echo "Instalando o Zabbix Server, Frontend e Agent..."
    read -p "Pressione Enter para continuar..."
    echo

    sudo apt update
    sudo apt install --install-recommends zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf \
        zabbix-sql-scripts zabbix-agent2 zabbix-agent2-plugin-*
    sudo apt install mysql-server -y
}

# Verificar a versão do Ubuntu antes de começar
check_ubuntu_version

# Executar os passos de instalação
install_zabbix_dependencies
add_zabbix_repository
install_zabbix

echo
echo "Instalação do Zabbix Server e Agent concluída com sucesso."
echo
