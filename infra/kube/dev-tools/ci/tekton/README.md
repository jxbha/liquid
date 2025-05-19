# tekton

## Overview

Switched to Tekton to align with IBM Cloud’s native CI/CD tooling (IKS uses Tekton under the hood) and to get smoother support for rootless image builds using BuildKit. Drone’s Kubernetes runner is community-driven and not recommended for production, so we're switching to a more idiomatic choice.
