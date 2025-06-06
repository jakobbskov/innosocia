# Nextcloud on Raspberry Pi 4 (8 GB)

This repository provides a Docker based workflow for hosting Nextcloud on a Raspberry Pi 4 with 8 GB RAM.  The instructions summarize a production-ready setup inspired by the “version 3” guide referenced in the project description.

## Hardware prerequisites

- Raspberry Pi 4 with 8 GB RAM and a reliable power supply
- 64‑bit Raspberry Pi OS (recommended to utilise all memory)
- External SSD/HD for Nextcloud data storage (Btrfs suggested if you want snapshot‑based backups)
- Stable internet connection and a domain name pointing to your Pi

## Software prerequisites

- Docker and Docker Compose installed on the Pi
- Ports 80 and 443 reachable from the internet (or an alternative DNS challenge setup for Let's Encrypt)

Verify the installation with:

```bash
docker --version
docker compose version
```

## Basic installation steps

1. **Create a dedicated Docker network** so the containers can resolve each other by name:
   ```bash
   docker network create -d bridge nextcloud_net
   ```
2. **Review `docker-compose.yml`** which defines services for Nextcloud (Apache), MariaDB, Redis and an optional Nginx reverse proxy. Adjust the passwords, domain names and volume locations to suit your environment.
3. **Start the stack** with `./start` (or `docker compose -f docker-compose.yml up -d`) and browse to `https://cloud.example.com` to finish the installation.

The guide also covers optional topics such as log rotation, resource limits for each container and using Btrfs snapshots for quick backups and upgrades. See the comments in the configuration files for further pointers.

## Using the `start` script

The repository includes an executable `start` script that launches the Docker
Compose stack. Run it with:

```bash
./start
```

The script checks that `docker` and `docker compose` (or `docker-compose`) are
available and prints a helpful error if they are missing. When the requirements
are met it executes:

```bash
docker compose up -d
```

You can extend the script with additional tasks as needed.

## Development dependencies

The `scripts/run_tests.sh` helper relies on `shellcheck` and `yamllint` for linting.
Install them via your package manager, for example:

```bash
sudo apt-get install shellcheck yamllint
```

## Running tests

The `scripts/run_tests.sh` script performs ShellCheck and
`yamllint` checks on the repository. Execute it with:

```bash
bash scripts/run_tests.sh
```

## License

This project is released under the [MIT License](LICENSE).

