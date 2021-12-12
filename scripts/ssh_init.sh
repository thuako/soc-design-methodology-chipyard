#!/bin/bash

sudo apt-get update
sudo apt-get -y install curl openssh-server
sudo echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
service ssh restart
mkdir -p ~/.ssh
touch ~/.ssh/authorized_keys
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDACyoUdyBjs4tmhLpKkvDK6pk/ZxvbgIN3W9PyWmsF1XXFpVZDWQE7uY7gS4/tllaZdafPYuJKqzyI1SYorCvz0i2xsirL2Zhcc/o7fdUk7eSDxwP7ReCZraJ1L7z9aiQ6VGzwAJLpMO5DYT9JCY1vDStynE9nS8sHuXHWUL2MubYPghrnUR0JUTQ4Ukd91RLtOrTumuAryM+JDZhtldVIsFq7aE7BoCZt3lmwCf4V7y0Y9SEyLjcuWE8aYOqUHWGemnsjPz90wWifzNBAcGCXk9jPtqxmvBO8NhVaJY5+s/JRuychQBV23qALrmODx34Hmzwl9sNPLtpm2MWfW5IX+rUff3FdawUZGk8s7J0o76GPY3Pir3byKNZHPxPfcaN5kN/mUcDPL8SZEt4Va/pAm77CiIu8bQFeoCUUN8Tp4UhithRBKrGUni30jC+YQtLkAzniv4jf+WKSVOQCsJfXzIqw/k/o1RXjCVCFjp5+z5LkTgG+YG4SpU9Hnz2uMZ0= thuako@thuako-MacBook-Air.local' >> ~/.ssh/authorized_keys

cd ~/chipyard/sims/verilator
make verilog
