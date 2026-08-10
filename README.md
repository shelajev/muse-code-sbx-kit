# Muse Code Sandbox Kit

Docker Sandboxes kit for running [Meta's Muse Code](https://dev.meta.ai/docs/muse-code) terminal coding agent inside an isolated sandbox.

The kit installs the official `muse` binary and permits only the Meta services needed for installation, updates, authentication, and model requests. Muse configuration, credentials, and sessions live under the sandbox user's persistent home directory.

> Docker Sandbox kits are currently experimental and their schema and CLI may change.

## Prerequisites

- The standalone [`sbx` CLI](https://docs.docker.com/ai/sandboxes/get-started/) with kit-spec V2 support (Docker Sandboxes 0.38 or later)
- Access to Muse Code (currently beta)

On macOS, install `sbx` from Docker's Homebrew tap and sign in:

```bash
brew trust docker/tap
brew install docker/tap/sbx
sbx login
```

On Ubuntu, install it from Docker's apt repository:

```bash
curl -fsSL https://get.docker.com | sudo REPO_ONLY=1 sh
sudo apt-get install docker-sbx
sudo usermod -aG kvm "$USER"
newgrp kvm
sbx login
```

See Docker's [Get started with Docker Sandboxes](https://docs.docker.com/ai/sandboxes/get-started/) page for supported operating systems, hardware requirements, Windows installation, and manual downloads.

## Quick start

Run the published kit directly from Docker Hub:

```bash
sbx run --kit docker.io/olegselajev241/muse-code-sbx-kit:latest muse-code .
```

Docker Hub is an allowed kit source by default. To run the kit directly from GitHub instead, allow this repository as a source once:

```bash
sbx settings set kit.allowedSources '["docker.io/", "github.com/shelajev/"]'
sbx run --kit git+https://github.com/shelajev/muse-code-sbx-kit.git muse-code .
```

On first use, Muse asks you to sign in. Follow the URL it prints in your terminal and finish authentication in your local browser. The resulting `~/.config/muse/auth.json` remains in the sandbox's persistent home directory.

Muse also supports API-key authentication through `META_API_KEY`. Do not place a key in `spec.yaml` or commit it to this repository.

## Named sandbox

Create a sandbox that you can reattach to later:

```bash
sbx create --name muse-current \
  --kit docker.io/olegselajev241/muse-code-sbx-kit:latest muse-code .

sbx run muse-current
```

When working from a local clone, the wrapper uses the local kit directory:

```bash
./run.sh muse-current
```

## How it works

- **Base image:** `docker/sandbox-templates:shell-docker`
- **Install:** runs Meta's official installer as the sandbox user; it downloads the launcher from `api.meta.ai` and places `muse` in `~/.local/bin`
- **Entrypoint:** `muse`, which opens the interactive terminal UI
- **Persistence:** Muse stores auth in `~/.config/muse/` and sessions in `~/.local/share/muse/`; the sandbox home persists across restarts
- **Updates:** Muse's launcher checks the stable release channel and can update the binary

## Network policy

The kit allows only the services Muse needs:

- `dev.meta.ai` — installer and documentation
- `auth.meta.com` — device authentication
- `api.meta.ai` — release metadata and Muse model requests
- `lookaside.facebook.com` — platform binary downloads

Your coding workflow may need additional hosts, such as GitHub or package registries. Add those hosts under `permissions.network.allow` in a fork or combine this sandbox kit with an appropriate mixin kit.

## Validation

```bash
sbx kit validate .
sbx kit inspect .
./scripts/pack.sh /tmp/muse-code-sbx-kit.zip
sbx kit validate /tmp/muse-code-sbx-kit.zip
bash -n run.sh scripts/*.sh
```

For a live smoke test after creating a named sandbox:

```bash
sbx exec muse-current -- sh -lc 'MUSE_NO_AUTO_UPDATE=1 muse --version'
```

## Publishing

Every commit pushed to `main` is validated and published as `docker.io/olegselajev241/muse-code-sbx-kit:latest`. The workflow uses `scripts/push.sh`, which stages only `spec.yaml` and the optional `files/` tree before publishing; repository metadata such as `.git/` is never included. The workflow can also be run manually. It requires a Docker Hub access token with read/write permission in the `DOCKERHUB_TOKEN` repository secret.

## License

Apache 2.0. See [LICENSE](LICENSE).
