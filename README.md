# Nextcloud version 3 on Raspberry Pi 4 (8 GB)

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
2. **Database container** – run MariaDB with some InnoDB tuning. Mount a folder (or volume) for `/var/lib/mysql` and add a custom configuration file e.g.:
   ```ini
   # mariadb-conf.d/99-nextcloud.cnf
   [mysqld]
   innodb_buffer_pool_size = 1024M
   innodb_flush_method = O_DIRECT
   innodb_flush_log_at_trx_commit = 2
   innodb_log_file_size = 256M
   ```
3. **Redis container** for caching and file locking:
   ```bash
   docker run -d --name nextcloud_redis --network nextcloud_net \
      redis:7-alpine redis-server --appendonly no
   ```
4. **Nextcloud container** using the official Apache image. Connect it to `nextcloud_net` and supply the database credentials and trusted domain environment variables. Example compose snippet:
   ```yaml
   nextcloud:
     image: nextcloud:27-apache
     networks:
       - nextcloud_net
     environment:
       - MYSQL_HOST=nextcloud_db
       - MYSQL_DATABASE=nextcloud
       - MYSQL_USER=nextcloud
       - MYSQL_PASSWORD=<password>
       - NEXTCLOUD_TRUSTED_DOMAINS=cloud.example.com
     volumes:
       - nextcloud_html:/var/www/html
   ```
5. **Nginx reverse proxy** – handle HTTPS for your domain and forward traffic to the Nextcloud container. Combine it with the official `certbot` image to obtain and renew Let's Encrypt certificates. Nginx serves the ACME challenge files from a shared volume and reloads when certificates are renewed.
6. **Start the stack** via Docker Compose and browse to `https://cloud.example.com` to finish the initial Nextcloud installation.

The guide also covers optional topics such as log rotation, resource limits for each container and using Btrfs snapshots for quick backups and upgrades. See the comments in the configuration files for further pointers.

## Using the `start` script

The repository includes a `start` script. Make it executable and run it to automate any custom tasks you add:

```bash
chmod +x start
./start
```

Currently the script is empty; modify it to fit your own deployment workflow (for example, to pull images and launch containers with Docker Compose).

## License

This project is released under the [MIT License](LICENSE).

