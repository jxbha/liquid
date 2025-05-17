# drone

## Overview
First CI implementation with Gitea. We wanted an external CI platform to test integrations.

Coming from GitLab CI, the pipeline approach is very similar. However, the obfuscation of the `drone/git` image, the old alpine base of the `drone-runner-kube` and the perhaps symptomatic cert-injection issues can cause a small amount of friction.

We plan move to either Argo Workflows or Jenkins soon.

## Considerations

- drone-runner-kube is [community-driven](https://github.com/drone-runners/drone-runner-kube?tab=readme-ov-file). the documentation in [drone.io](https://docs.drone.io/pipeline/kubernetes/overview/), while still present, should be validated carefully

- if the webhook is accidentally deleted in the git repo, it can be regenerated very easily following the steps documented [here](https://docs.drone.io/cli/repo/drone-repo-repair/):


        $ drone repo repair octocat/hello-world
