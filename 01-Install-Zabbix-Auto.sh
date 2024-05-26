#!/bin/bash

#tail -f /var/log/01-Install-Zabbix-Auto.log

# Variável do caminho do Log dos Script
# opções do comando cut: -d (delimiter), -f (fields)
# $0 (variável de ambiente do nome do comando)
LOG="/var/log/$(echo "$0" | cut -d'/' -f2).log"

# Função para verificar a versão do Ubuntu
check_ubuntu_version() {
    if [ "$(lsb_release -cs)" != "noble" ]; then
        echo
        echo
        echo "Este script é destinado apenas para Ubuntu 24.04 Noble. Saindo."
        echo "Este script é destinado apenas para Ubuntu 24.04 Noble. Saindo." >> "$LOG"
        exit 1
    fi
}

# Função para instalar as dependências do Zabbix Server e Agent
install_zabbix_dependencies() {
    echo 
    echo 
    echo "Instalando as dependências do Zabbix Server e Agent..."
    echo "Instalando as dependências do Zabbix Server e Agent..." >> "$LOG"
    echo
    echo >> "$LOG"
    read -p "Pressione Enter para continuar..."
    read -p "Pressione Enter para continuar..." >> "$LOG"
    echo
    echo >> "$LOG"
    
    sudo apt update &>> "$LOG"
    sudo apt install --install-recommends traceroute nmap snmp snmpd snmp-mibs-downloader apt-transport-https \
        software-properties-common git vim fping &>> "$LOG"
}

# Função para adicionar o repositório do Zabbix
add_zabbix_repository() {
    echo
    echo >> "$LOG"
    echo "Adicionando o repositório do Zabbix..." >>
    echo "Adicionando o repositório do Zabbix..." >> "$LOG"
    read -p "Pressione Enter para continuar..." >> "$LOG"
    echo
    echo >> "$LOG"
    
    wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-6+ubuntu24.04_all.deb &>> "$LOG"
    sudo dpkg -i zabbix-release_6.0-6+ubuntu24.04_all.deb &>> "$LOG"
}

# Função para instalar o Zabbix Server, Frontend e Agent
install_zabbix() {
    echo
    echo >> "$LOG"
    echo "Instalando o Zabbix Server, Frontend e Agent..." >> 
    echo "Instalando o Zabbix Server, Frontend e Agent..." >> "$LOG"
    read -p "Pressione Enter para continuar..." >> "$LOG"
    echo
    echo >> "$LOG"

    sudo apt update &>> "$LOG"
    sudo apt install --install-recommends zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf \
        zabbix-sql-scripts zabbix-agent2 zabbix-agent2-plugin-* &>> "$LOG"
    sudo apt install mysql-server -y &>> "$LOG"
}

# Verificar a versão do Ubuntu antes de começar
check_ubuntu_version

# Executar os passos de instalação
install_zabbix_dependencies
add_zabbix_repository
install_zabbix

echo
echo >> "$LOG"
echo "Instalação do Zabbix Server e Agent concluída com sucesso." >> 
echo "Instalação do Zabbix Server e Agent concluída com sucesso." >> "$LOG"
echo
echo >> "$LOG"
