<!-- omit in toc -->
# GitHub Actions self-hosted runners for Kubernetes

Unofficial support for running [GitHub Actions](https://github.com/features/actions) [self-hosted runners](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/hosting-your-own-runners) (https://github.com/actions/runner) on Kubernetes.

- [Caveats](#caveats)
- [Installation](#installation)
- [Upgrading](#upgrading)
- [Hacking](#hacking)
  - [Running the most recently built image from a local checkout](#running-the-most-recently-built-image-from-a-local-checkout)

## Caveats

* Not associated with, provided by, or supported by GitHub.
* Runs a Docker-in-Docker container in your cluster **in priviledged mode** to facilitate running Docker-based Actions. **Priviledge escalatations are almost certainly possible as a result**.
* Credentials are not persisted in any manner outside of the container filesystem. This, combined with the fact that the token provided during the setup process has a 1h TTL, means that **service will be interrupted if runner Pods are deleted or evicted**.
* A limited set of development utilities are provided. Work to keep the set of installed utilities in sync with upstream is TBD.
* **[Not reccommended for use on open source repositories](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/about-self-hosted-runners#self-hosted-runner-security-with-public-repositories).**

## Installation

<!-- omit in toc -->
### Configure your cluster with permisions to pull Docker images from GitHub Packages

* [Create a GitHub Personal Access Token](https://github.com/settings/tokens/new) with `repo` and `packages:read` scope.
    * Copy the token provided.
* Create a secret named `github-package-registry` with this token in the Kubernetes namespace in which you wish to install the runner:

```
kubectl --namespace <namespace> create secret docker-registry github-package-registry \
    --docker-server=docker.pkg.github.com --docker-username=<username> --docker-password=<token>
```

<!-- omit in toc -->
### Create a secret with a fresh runner token

* Visit the Repository **Settings** page for your repository.
  * Click **Actions** in the sidebar.
  * In the **Self-hosted runners** section, click **Add runner**.
  * Copy the token provided.
* Create a secret named `actions-runner` with this token in the Kubernetes namespace in which you wish to install the runner:

```
kubectl --namespace <namespace> create secret generic actions-runner \
    --from-literal=REPOSITORY=<repository> \
    --from-literal=TOKEN=<token>
```

* Install the actions runner in your namespace:

```
kubectl --namespace <namespace> apply -k https://github.com/urcomputeringpal/actions-runner-kubernetes/releases/<latest release>
```

## Upgrading

Upgrading currently requires updating the token used to register your runners.

* Delete the existing secret:

```
kubectl -n kube-system delete secret actions-runner
```

* Create a [new secret](#create-a-secret-with-a-fresh-runner-token)
* Upgrade to the [latest release](https://github.com/urcomputeringpal/actions-runner-kubernetes/releases)

```
kubectl --namespace <namespace> apply -k https://github.com/urcomputeringpal/actions-runner-kubernetes?ref=v2.169.1-ucp3
```

* Cleanup any stale runners listed in your repository's Settings.

## Hacking

### Running the most recently built image from a local checkout

```
kubectl -n <namespace> apply -k kustomize
```
