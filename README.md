# PMB
PMB application with docker
Custom correction for specific PMB version
Automatic backup on a different server

PMB 7.3.2
PHP 7.3
Apache 2.4.38
MySQL 5.7


## Installation
Get a OVH VPS
Follow instuctions https://docs.ovh.com/fr/vps/debuter-avec-vps/


## Reset super user password
```shell
ssh vps-XXXXXXXX.vps.ovh.net
passwd
```

## Update server
```shell
timedatectl set-timezone Europe/Paris
apt update
apt upgrade
apt autoremove
```


## Disable ssh root connexion
```shell
vi /etc/ssh/sshd_config
PermitRootLogin no
/etc/init.d/ssh restart
```


## Add pmb user
```shell
adduser pmb
usermod -aG root,adm,sudo pmb
```


## Installation of Docker
```shell
sudo apt install docker.io docker-compose make git htop
sudo usermod -aG docker pmb
(logout then login)
```


## Get sources
```shell
ssh pmb@vps-XXXXXXXX.vps.ovh.net
git clone https://github.com/AlexCorum/pmb.git pmb_sources
mv pmb_sources/* .
mv pmb_sources/.git .
mv pmb_sources/.gitignore .
rm -rf pmb_sources
```


## Add and update params
```shell
cp docker/.env.dist docker/.env
cp docker/php7/conf/db_param.inc.php.dist docker/php7/conf/db_param.inc.php
cp docker/php7/conf/opac_db_param.inc.php.dist docker/php7/conf/opac_db_param.inc.php
```


## Get pmb sources from forge
It's not possible to get directly the source.
We have to wget and scp
Goto to https://forge.sigb.net/projects/pmb/files
Download file
```shell
scp pmb7.3.2.zip pmb@vps-XXXXXXXX.vps.ovh.net:docker/php7/forge/.
```


## First installation  pmb
Disable the following lines in docker/php7/Dockerfile (or add comment)
```dockerfile
RUN mv ${APACHE_DOCUMENT_ROOT}/tables/install.php ${APACHE_DOCUMENT_ROOT}/tables/noinstall.php
RUN mv ${APACHE_DOCUMENT_ROOT}/tables/install_rep.php ${APACHE_DOCUMENT_ROOT}/tables/noinstall_rep.php
```
and open
```
http://vps-XXXXXXXX.vps.ovh.net/tables/install.php
```


## Running docker
Change domain in docker/traefik.toml

```shell
vi ~/docker/traefik.toml

[docker]
domain = "cdi.ovh"
```

Run docker

```shell
docker network create web
cd ~/docker
touch acme.json
chmod 600 acme.json
make rebuild
```


## Update source from git
```shell
cd ~
git pull
```


## Cron to backup to Kimsufi server
Share public key with kimsufi server

From user
```shell
ssh-keygen
ssh-copy-id -i ~/.ssh/id_rsa pmb@KIMSUFI-SERVER
ssh pmb@KIMSUFI-SERVER
```

Create backup-pmb script
```shell
sudo vi /etc/cron.daily/backup-pmb
```

```
#!/bin/sh
# cron script for backup-pmb
runuser -u pmb -- make -C /home/pmb ssh
runuser -u pmb -- find /home/pmb/archives/* -mtime +15 -exec rm {} \;
```

```shell
chmod 751 /etc/cron.daily/backup-pmb
crontab -l
```