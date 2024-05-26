#!/bin/bash

# Variável da Data Inicial para calcular o tempo de execução do script (VARIÁVEL MELHORADA)
# opção do comando date: +%T (Time)
HORAINICIAL=$(date +%T)

# Função para verificar a versão do Ubuntu
check_ubuntu_version() {
    if [ "$(lsb_release -cs)" != "noble" ]; then
        echo
        echo
        echo "Este script é destinado apenas para Ubuntu 24.04 Noble. Saindo."
        exit 1
    fi
}

# Função para instalar as dependências do Zabbix Server e Agent
install_zabbix_dependencies() {
    echo 
    echo 
    echo "Instalando as dependências do Zabbix Server e Agent..."
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
    echo "Adicionando o repositório do Zabbix..." 
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
    echo "Instalando o Zabbix Server, Frontend e Agent..." 
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

echo "Instalação do Zabbix Server e Agent concluída com sucesso."
	# script para calcular o tempo gasto (SCRIPT MELHORADO, CORRIGIDO FALHA DE HORA:MINUTO:SEGUNDOS)
	# opção do comando date: +%T (Time)
	HORAFINAL=`date +%T`
	# opção do comando date: -u (utc), -d (date), +%s (second since 1970)
	HORAINICIAL01=$(date -u -d "$HORAINICIAL" +"%s")
	HORAFINAL01=$(date -u -d "$HORAFINAL" +"%s")
	# opção do comando date: -u (utc), -d (date), 0 (string command), sec (force second), +%H (hour), %M (minute), %S (second), 
	TEMPO=`date -u -d "0 $HORAFINAL01 sec - $HORAINICIAL01 sec" +"%H:%M:%S"`
	# $0 (variável de ambiente do nome do comando)
	echo -e "Tempo gasto para execução do script $0: $TEMPO"
echo -e "Pressione <Enter> para concluir o processo."
# opção do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
echo -e "Fim do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\n"
read
exit 1
