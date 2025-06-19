#!/usr/bin/env bash

minikube cp <<'EOF'

    #!/usr/bin/env bash
    
    set -e

    sudo sed -i 's/^#DNS=$/DNS=10.96.0.10 192.168.124.1/' /etc/systemd/resolved.conf
    sudo sed -i 's/^#Domains=$/Domains=svc.cluster.local/' /etc/systemd/resolved.conf
    sudo systemctl restart systemd-resolved
    sudo systemctl restart containerd

    if [[ ! -d /opt/liquid ]]; then
        sudo mkdir -p /opt/liquid/{data-mana,data-registry,logs-mana,data-git}
        sudo chown -R 999:999 /opt/liquid/data-mana
    fi

EOF /home/docker/init.sh
minikube ssh 'sudo chmod +x /home/docker/init.sh && /home/docker/init.sh'
