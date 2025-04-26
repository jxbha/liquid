#!/bin/bash
podman push --tls-verify=false localhost:5000/helper:3
podman push --tls-verify=false localhost:5000/mana:latest
podman push --tls-verify=false localhost:5000/postgres:latest
