#!/bin/bash
sudo rm -rf /opt/liquid/data-mana/
sudo mkdir /opt/liquid/data-mana
sudo chown -R 999:999 /opt/liquid/data-mana/
sudo chmod -R 770 /opt/liquid/data-mana/
sudo ls -la /opt/liquid/data-mana
sudo rm -rf /opt/liquid/data-tools/
sudo mkdir /opt/liquid/data-tools
sudo chown -R 999:999 /opt/liquid/data-tools/
sudo chmod -R 770 /opt/liquid/data-tools/
sudo ls -la /opt/liquid/data-tools
