# Nextcloud Provisioning

This repository contains a `setup.sh` script for provisioning a Raspberry Pi with Nextcloud. The script installs Apache, PHP and MariaDB, downloads the latest Nextcloud release and configures the web server to serve it.

## Usage

```bash
sudo bash setup.sh
```

The installer will enable services so they start automatically. After running the script, visit `http://<your-pi-ip>/nextcloud` to complete the web-based setup.
