# PMB
PMB application with docker
Backup on a KIMSUFI server

PMB 7.3.2
PHP 7.3
Apache
MariaDB


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
mv pmb_sources/.git .
mv pmb_sources/.gitignore .
rm -rf pmb_sources
```


## Add params
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
scp pmb7.3.2.zip pmb@vps-XXXXXXXX.vps.ovh.net:docker/php7/forge/forge/.
```

## Running docker
```shell
cd ~/docker
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
ssh pmb@ns358473.ip-91-121-154.eu
```

From root
```shell
sudo -i
ssh-keygen
ssh-copy-id -i ~/.ssh/id_rsa pmb@KIMSUFI-SERVER
ssh pmb@ns358473.ip-91-121-154.eu
```

Create backup-pmb script
```shell
sudo -i
vi /etc/cron.daily/backup-pmb
```

```
#!/bin/sh
# cron script for backup-pmb
cd /home/pmb
make ssh
find archives/* -mtime +15 -exec rm {} \;
```

```shell
chmod 751 /etc/cron.daily/backup-pmb
```