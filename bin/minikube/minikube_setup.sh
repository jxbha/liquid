#!/bin/bash

#minikube start -c containerd --cni calico -d kvm2
minikube cp bin/minikube_init.sh /home/docker/init.sh
minikube ssh 'sudo chmod +x init.sh && ./init.sh'
