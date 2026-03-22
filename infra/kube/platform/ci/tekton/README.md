# tekton

## Overview

Switched to Tekton to align with IBM Cloud’s native CI/CD tooling (IKS uses Tekton under the hood) and to get smoother support for rootless image builds using BuildKit. Drone’s Kubernetes runner is community-driven and not recommended for production, so we're switching to something a little more industry-standard.

## Pipelines

The cluster currently runs one main pipeline:

    ├── common                     # general Tekton resources, potentially reusable
    │   ├── git-clone.yaml
    │   ├── kustomization.yaml
    │   ├── listener.yaml
    │   └── rbac.yaml
    ├── kustomization.yaml
    ├── mana                       # dedicated Tekton resources, meant for `mana` application test, rebuild and redeploy
    │   ├── ci-pipeline.yaml
    │   ├── ci-tt.yaml
    │   ├── configs
    │   │   ├── buildkit
    │   │   │   └── config.yaml
    │   │   └── kustomization.yaml
    │   ├── deploy.yaml
    │   ├── go-build-test.yaml
    │   ├── image-build-push.yaml
    │   ├── kustomization.yaml
    │   └── triggerbinding.yaml
    └── README.md

