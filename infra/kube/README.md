# infra/kube

## Overview
    .
    ├── containers
    ├── dev-tools
    │   ├── ci
    │   │   ├── auth
    │   │   └── tekton
    │   │       ├── common
    │   │       ├── mana
    │   │       │   └── configs
    │   │       │       └── buildkit
    │   │       └── test
    │   ├── db
    │   ├── gitea
    │   └── registry
    ├── mana
    │   ├── app
    │   └── db
    ├── overlays
    │   ├── dev
    │   │   └── patches
    │   └── prod
    │       └── patches
    ├── utility
    │   ├── cronjobs
    │   │   ├── pipeline
    │   │   └── volume
    │   ├── helper
    │   ├── jobs
    │   ├── kubetool
    │   └── ssl
    └── vendor
        ├── all
        ├── common
        └── networking


`mana` is the primary application - our environment is meant to support this. Eventually we may add additional workload, just to add some complexity.

The cluster consists of three manually-created namespaces, `app`, `dev-tools`, `monitoring`.
- `app` includes `mana`, a database running postgres, and a few ancillary jobs for getting the application running.
- `dev-tools` is a general namespace for various developer tooling - git repository (gitea), container registry (registry:2, perhaps harbor eventually), a database for general storage, and Tekton for CI/CD.
- `monitoring` uses the [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) to track everything. We have a custom alert, dashboard, and email notifications using [Brevo's](https://www.brevo.com/) SMTP server and [Cloudflare's](https://www.cloudflare.com/) email forwarding. Sendgrid would have been a cool alternative as a common industry tool, but they deprecated their free tier July of this year (2025).

Versioning is handled through `versions.txt`, dictating custom resource, download URL, and category. Category is used to drop it into `common/` or `networking/` for kustomize to isolate depending on environment. This may eventually be handled within Kubernetes using Tekton.

`utility/` is a bit of a mess. It currently holds kubernetes resources for jobs (custom container image management), cronjobs (cleanup for pipeline)), and various custom images/dockerfiles
