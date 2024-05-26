#Autor: Carlos J S Bezerra<br>
#Data de criação: 25/05/2024<br>
#Data de atualização: 01/05/2024<br>
#Versão: 1.0<br>


Conteúdo estudado nessa implementação:<br>
#01_ Instalando as Dependências do Zabbix Server e Agent<br>
#02_ Adicionando o Repositório do Zabbix no Ubuntu Server<br>
#03_ Instalando o Zabbix Server, Frontend e Agent<br>
#04_ Criando a Base de Dados do Zabbix Server no MySQL Server<br>
#05_ Testando o acesso a Base de Dados do Zabbix Server no MySQL Server<br>
#06_ Populando as Tabelas no Banco de Dados do Zabbix Server<br>
#07_ Editando os arquivos de Configuração do Zabbix Server e Agent<br>
#08_ Habilitando o Serviço do Zabbix Server e Agent<br>
#09_ Verificando o Serviço e Versão do Zabbix Server e Agent<br>
#10_ Configurando o Zabbix Server via Navegador<br>
#11_ Verificando a Porta de Conexão do Zabbix Server e Agent<br>
#12_ Adicionado o Usuário Local no Grupo Padrão do Zabbix Server<br>
#13_ Localização dos diretórios principais do Zabbix Server e Agent<br>
#14_ Instalando os Agentes do Zabbix no Linux Mint e no Windows 10<br>
#15_ Criando os Hosts de Monitoramento dos Agentes no Zabbix Server
#16_ Estressando o Servidor Ubuntu Server para verificar as mudanças no Gráfico

Site Oficial do Zabbix: https://www.zabbix.com/<br>

#01_ Instalando as Dependências do Zabbix Server e Agent2<br>

	#atualizando as lista do apt
	sudo apt update

	#instalando as dependências do Zabbix
	sudo apt install --install-recommends traceroute nmap snmp snmpd snmp-mibs-downloader apt-transport-https \
	software-properties-common git vim fping

#02_ Adicionando o Repositório do Zabbix no Ubuntu Server<br>


	#download do repositório do Zabbix Server
	wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-6+ubuntu24.04_all.deb

	#instalação do repositório do Zabbix Server
	#opção do comando dpkg: -i (install)
	sudo dpkg -i zabbix-release_6.0-6+ubuntu24.04_all.deb

#03_ Instalando o Zabbix Server, Frontend e Agent2<br>
	
	#atualizando as lista do Apt com o novo repositório do Zabbix Server
	sudo apt update
	
	#instalando o Zabbix Server e Agent2
	sudo apt install --install-recommends zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf \
	zabbix-sql-scripts zabbix-agent2 zabbix-agent2-plugin-*
	
	sudo apt install mysql-server -y


#04_ Criando a Base de Dados do Zabbix Server no MySQL Server<br>

	#opções do comando mysql: -u (user), -p (password)
	sudo mysql -u root -p

```sql
/* Criando o Banco de Dados Zabbix Server */
CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

/* Criando o Usuário Zabbix com a Senha Zabbix do Banco de Dados Zabbix */
CREATE USER 'zabbix'@'localhost' IDENTIFIED WITH mysql_native_password BY 'zabbix';
GRANT USAGE ON *.* TO 'zabbix'@'localhost';
GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';
FLUSH PRIVILEGES;

/* Habilitando a opção de Criação de Função log_bin_trust_function_creators no MySQL Server */
SET GLOBAL log_bin_trust_function_creators = 1;

/* Listando os Bancos de Dados do MySQL */
SHOW DATABASES;

/* Verificando o Usuário Zabbix criado no Banco de Dados MySQL Server */
SELECT user,host FROM mysql.user WHERE user='zabbix';

/* Saindo do Banco de Dados */
exit
```

#05_ Testando o acesso a Base de Dados do Zabbix Server no MySQL Server<br>

	#opções do comando mysql: -u (user), -p (password)
	sudo mysql -u zabbix -p

```sql
/* Listando os Bancos de Dados do MySQL */
SHOW DATABASES;

/* Acessando o Banco de Dados Zabbix */
USE zabbix;

/* Saindo do Banco de Dados */
exit
```


#06_ Populando as Tabelas no Banco de Dados do Zabbix Server utilizando o arquivo de Esquema<br>

	#opções do comando mysql: -u (user), -p (password), zabbix (database)
	sudo zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | sudo mysql --default-character-set=utf8mb4 \
	-uzabbix -pzabbix zabbix 

	#opções do comando mysql: -u (user), -p (password)
	sudo mysql -u zabbix -p

```sql
/* Listando os Bancos de Dados do MySQL */
SHOW DATABASES;

/* Acessando o Banco de Dados Zabbix */
USE zabbix;

/* Verificando as Tabelas criadas pelo Script */
SHOW TABLES;

/* Verificando os Usuários criados pelo Script */
SELECT username,passwd FROM users;

/* Saindo do Banco de Dados */
exit
```

	#Desabilitando a opção de Criação de Função no MySQL Server

	#opções do comando mysql: -u (user), -p (password)
	sudo mysql -u root -p

```sql
/* Desabilitando a opção de Criação de Função log_bin_trust_function_creators no MySQL Server */
SET GLOBAL log_bin_trust_function_creators = 0;

/* Saindo do Banco de Dados */
exit
```

#07_ Editando os arquivos de Configuração do Zabbix Server e Agent<br>

	#editando o arquivo de configuração do Zabbix Server
	sudo vim /etc/zabbix/zabbix_server.conf
	INSERT

		#descomentar e alterar o valor da variável DBHost= na linha: 95
		DBHost=localhost

		#deixar o padrão da variável DBName= na linha: 107
		DBName=zabbix

		#deixar o padrão da variável DBUser= na linha: 123
		DBUser=zabbix

		#descomentar e alterar o valor da variável DBPassword= na linha: 131
		DBPassword=zabbix
	
	#salvar e sair do arquivo
	ESC SHIFT : x <Enter>

	#editando o arquivo de configuração do Zabbix Agent2
	sudo vim /etc/zabbix/zabbix_agent2.conf
	INSERT

		#alterar o valor da variável Server= na linha: 80
		Server=172.16.1.20

		#alterar o valor da variável ServerActive= na linha: 133
		ServerActive=172.16.1.20

		#alterar o valor da variável Hostname= na linha: 144
		Hostname=NomeDoServidor

		#descomentar o valor da variável RefreshActiveChecks= na linha 204
		RefreshActiveChecks=5s
	
	#salvar e sair do arquivo
	ESC SHIFT : x <Enter>

#08_ Habilitando o Serviço do Zabbix Server e Agent2<br>

	#habilitando o serviço do Zabbix Server e Agent2
	sudo systemctl daemon-reload
	sudo systemctl restart zabbix-server zabbix-agent2 apache2
	sudo systemctl enable zabbix-server zabbix-agent2 apache2

#09_ Verificando o Serviço e Versão do Zabbix Server e Agent2<br>

	#verificando o serviço do Zabbix Server e Agent2
	sudo systemctl status zabbix-server zabbix-agent2
	sudo systemctl restart zabbix-server zabbix-agent
	sudo systemctl stop zabbix-server zabbix-agent
	sudo systemctl start zabbix-server zabbix-agent

	#analisando os Log's e mensagens de erro do Servidor do Zabbix (NÃO COMENTADO NO VÍDEO)
	#opção do comando journalctl: -t (identifier), -x (catalog), -e (pager-end), -u (unit)
	sudo journalctl -xeu zabbix-server
	sudo journalctl -t zabbix_agent2
	sudo journalctl -xeu zabbix-agent2

	#verificando a versão do Zabbix Server e Agent2
	#opção do comando zabbix_server: -V (version)
	#opção do comando zabbix_agentd: -V (version)
	sudo zabbix_server -V
	sudo zabbix_agent2 -V

#10_ Configurando o Zabbix Server via Navegador<br>

	dpkg-reconfigure locales
	- pt_BR.UTF-8 UTF-8

	firefox ou google chrome: http://endereço_ipv4_ubuntuserver/zabbix

	#Configuração inicial do Zabbix Server
	Welcome to Zabbix 7.0
		Default language: English (en_US)
			<Next step>
		Check of pre-requisites
			<Next step>
		Configure DB connection
			Database type: MySQL
			Database host: localhost
			Database port: 0 (use default port)
			Database name: zabbix
			Store credentials in: Plain text
			User: zabbix
			Password: zabbix
			<Next step>
		Settings
			Zabbix server name: wssuporte
			Default time zone: (UTC-03:00) America/Sao_Paulo
			Default theme: Dark
			<Next step>
		Pre-installation summary
			<Next step>
		Install
			<Finish>
	
	#Acessando o Painel de Gerenciamento do Zabbix Server
	Username: Admin
	Password: zabbix
	Yes: Remember me for 30 days
	<Sign in>


#11_ Verificando a Porta de Conexão do Zabbix Server e Agent<br>

	#OBSERVAÇÃO IMPORTANTE: no Ubuntu Server as Regras de Firewall utilizando o comando: 
	#iptables ou: ufw está desabilitado por padrão (INACTIVE), caso você tenha habilitado 
	#algum recurso de Firewall é necessário fazer a liberação do Fluxo de Entrada, Porta 
	#e Protocolo TCP do Serviço corresponde nas tabelas do firewall e testar a conexão.

	#opção do comando lsof: -n (network number), -P (port number), -i (list IP Address), -s (alone directs)
	sudo lsof -nP -iTCP:'10050,10051' -sTCP:LISTEN



#12_ Adicionado o Usuário Local no Grupo Padrão do Zabbix Server<br>

	#opções do comando usermod: -a (append), -G (groups), $USER (environment variable)
	sudo usermod -a -G zabbix $USER
	newgrp zabbix
	id
	
	#recomendado reinicializar a máquina para aplicar as permissões
	sudo reboot

#13_ Localização dos diretórios principais do Zabbix Server e Agent<br>

	/etc/zabbix/*                   <-- Diretório dos arquivos de Configuração do serviço do Zabbix
	/etc/zabbix/zabbix_server.conf  <-- Arquivo de Configuração do Zabbix Server
	/etc/zabbix/zabbix_agent2.conf  <-- Arquivo de Configuração do Zabbix Agent
	/var/log/zabbix*                <-- Diretório dos arquivos de Log's do serviço do Zabbix
	/usr/share/zabbix*              <-- Diretório dos arquivos do Site do serviço do Zabbix


#14_ Instalando os Agentes do Zabbix no Linux Mint e no Windows 10<br>

	#Link de referência do download: https://www.zabbix.com/br/download_agents

	#OBSERVAÇÃO IMPORTANTE: ATÉ O MOMENTO DA GRAVAÇÃO DESSE VÍDEO, O AGENTE PARA O
	#SISTEMA MICROSOFT NÃO DISPONIBILIZA A VERSÃO 7.0, SOMENTE A VERSÃO 6.4.x DO 
	#ZABBIX AGENT.

	Windows, Any, amd64, v6.4, OpenSSL, MSI: 6.4.14 (ATUALIZADO NO DIA 05/05/2024)
	https://cdn.zabbix.com/zabbix/binaries/stable/6.4/6.4.14/zabbix_agent2-6.4.14-windows-amd64-openssl.msi

	#Instalação Manual do Zabbix Agent 2 para Microsoft
	Pasta de Download
		Welcome to the Zabbix Agent 2 (64-bit) Setup Wizard <Next>
		End-User License Agreement
			(On) I accept the therms in the License Agreement <Next>
		Custom Setup
			(On) Zabbix Agent 2 (64-bit) <Next>
		Zabbix Agent service configuration
			Host name: windows10
			Zabbix server IP/DNS: 172.16.1.20
			Agent listen port: 10050
			Server or Proxy for active checks: 172.16.1.20
			(Off) Enable PSK
			(On) Add agent location to the PATH <Next>
		Ready to install Zabbix Agent 2 (64-bit) <Install>
			Zabbix Agent 2 MSI package (64)-bit <Sim>
		Completed the Zabbix Agent 2 (64-bit) <Finish>
	
	#Verificação da instalação do Zabbix Agent 2 no Powershell
	#opção do comando netstat: -a (All connections), -n (addresses and port numbers)
	Powershell
		hostname
		Get-Service 'Zabbix Agent 2'
		netstat -an | findstr 10050
	
	#Localização do arquivo de configuração do Zabbix Agent 2
	C:\Program Files\Zabbix Agent 2\
		zabbix_agent2.conf

	#Link de referência do download: https://www.zabbix.com/br/download
	
	SELECIONAR: 7.0 PRE-RELEASE, Ubuntu, 22.04 (Jammy), Agent 2
	wget https://repo.zabbix.com/zabbix/6.5/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.5-1+ubuntu22.04_all.deb

	#instalando o repositório do Zabbix Agent2
	#opção do comando dpkg: -i (install)
	sudo dpkg -i zabbix-release_*.deb

	#atualizando as lista do Apt com o novo repositório do Zabbix Agent2
	sudo apt update

	#instalando as dependências do Zabbix Agent2
	sudo apt install traceroute nmap snmp snmpd snmp-mibs-downloader apt-transport-https \
	software-properties-common git vim

	#instalando o Zabbix Agent2
	#opção do comando apt: --install-recommends (Consider suggested packages as a dependency for installing)
	sudo apt install --install-recommends zabbix-agent2 zabbix-agent2-plugin-*

	#editando o arquivo de configuração do Zabbix Agent2
	sudo vim /etc/zabbix/zabbix_agent2.conf
	INSERT

		#alterar o valor da variável Server= na linha: 80
		Server=172.16.1.20

		#alterar o valor da variável ServerActive= na linha: 133
		ServerActive=172.16.1.20

		#alterar o valor da variável Hostname= na linha: 144
		Hostname=linuxmint213
		
		#descomentar o valor da variável RefreshActiveChecks= na linha 204
		RefreshActiveChecks=5s
	
	#salvar e sair do arquivo
	ESC SHIFT : x <Enter>
	
	#habilitando o serviço do Zabbix Agent2
	sudo systemctl daemon-reload
	sudo systemctl enable zabbix-agent2
	sudo systemctl restart zabbix-agent2

	#verificando o serviço do Zabbix Agent2
	sudo systemctl status zabbix-agent2

	#opção do comando lsof: -n (network number), -P (port number), -i (list IP Address), -s (alone directs)
	sudo lsof -nP -iTCP:'10050' -sTCP:LISTEN

#15_ Criando os Hosts de Monitoramento dos Agentes no Zabbix Server<br>

	#Criação dos Host GNU/Linux e Microsoft Windows no Zabbix Server
	Data collection
		Hosts
			<Create host>
				Host
					Host name: linuxmint213
					Visible name: linuxmint213
					Templates: <Select>
						Template group: <Select>
							Templates/Operating systems
							Linux by Zabbix agent <Select>
					Host groups: <select>
						Discovered hosts <Select>
					Interfaces: Add:
						Agent: 
							DNS name: 172.16.1.110
							Connect to: IP
							Port: 10050
					Description: Desktop Linux Mint 21.3
					Monitored by proxy: (no proxy)
					Enable: On
				<Add>
	
	Data collection
		Hosts
			<Create host>
				Host
					Host name: windows10
					Visible name: windows10
					Templates: <Select>
						Template group: <Select>
							Templates/Operating systems
							Windows by Zabbix agent <Select>
					Host groups: <select>
						Discovered hosts <Select>
					Interfaces: Add:
						Agent: 
							DNS name: 172.16.1.193
							Connect to: IP
							Port: 10050
					Description: Desktop Microsoft Windows 10
					Monitored by proxy: (no proxy)
					Enable: On
				<Add>

#16_ Estressando o Servidor Ubuntu Server para verificar as mudanças no Gráfico<br>

	#instalando o software stress-ng e s-tui no Ubuntu Server (NÃO COMENTADO NO VÍDEO)
	sudo apt install stress-ng s-tui

	#verificando a versão do stress-ng e do s-tui (NÃO COMENTADO NO VÍDEO)
	sudo stress-ng --version
	sudo s-tui --version

	#verificando a carga atual do servidor Ubuntu (NÃO COMENTADO NO VÍDEO)
	#HORA ATUAL | TEMPO DE ATIVIDADE | NÚMERO DE USUÁRIOS LOGADOS | MÉDIA DE CARGA CPU 1=100% - (1M) (5M) (15M)
	sudo uptime

	#verificando o desempenho do servidor Ubuntu (NÃO COMENTADO NO VÍDEO)
	sudo top

	#estressando a CPU, RAM e DISK utilizando o stress-ng (pressione Ctrl+C para abortar)
	#opção do comando stress-ng: --hdd (start N workers continually writing, reading and 
	#removing temporary files.), --io (start N workers continuously calling sync(2) to 
	#commit buffer cache to disk.), --vm (start N workers continuously calling mmap(2)/
	#munmap(2) and writing  to  the  allocated  memory.), --timeout (run each stress test 
	#for at least T seconds)
	sudo stress-ng --hdd 8 --io 8 --vm 18 --cpu 8 --timeout 900s

	#parando alguns serviços do Ubuntu Server (NÃO COMENTADO NO VÍDEO)
	sudo systemctl stop tomcat10.service mongod.service netdata.service webmin.service

	#fazendo uma busca no disk utilizando o comando find (NÃO COMENTADO NO VÍDEO)
	#opção do comando find: -name (Base of file name), * (Qualquer coisa)
	sudo find / -name suporte*

=========================================================================================
