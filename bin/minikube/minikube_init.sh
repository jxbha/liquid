#!/bin/bash

sudo sed -i 's/^#DNS=$/DNS=10.96.0.10 192.168.124.1/' /etc/systemd/resolved.conf
sudo sed -i 's/^#Domains=$/Domains=svc.cluster.local/' /etc/systemd/resolved.conf
sudo systemctl restart systemd-resolved
sudo systemctl restart containerd

if [[ ! -d /opt/liquid ]]; then
    sudo mkdir -p /opt/liquid/data-mana
    sudo chown -R 999:999 /opt/liquid/data-mana
    sudo mkdir /opt/liquid/data-registry
    sudo mkdir /opt/liquid/logs-mana
    sudo mkdir /opt/liquid/data-git
fi
