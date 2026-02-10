# 🖥️ Ubuntu 22.04 XFCE Desktop with VNC & noVNC (Docker)

This repository provides a **Dockerized Ubuntu 22.04 desktop environment** using **XFCE**, accessible via:

- **VNC** (port `5901`)
- **Browser-based noVNC** (port `6080`)

It’s designed for **high-resource systems** (lots of RAM/CPU), development, testing, or remote GUI workflows.

> ⚠️ **Security warning**: This setup intentionally disables VNC authentication and uses a self-signed TLS certificate.  
> **DO NOT expose this container directly to the public internet.**

---

## ✨ Features

- Ubuntu **22.04 (Jammy Jellyfish)**
- Lightweight **XFCE4 desktop**
- **TigerVNC** server
- **noVNC** (access desktop from your browser)
- **Firefox** (from Mozilla Team PPA, not Snap)
- Common utilities preinstalled:
  - `git`, `curl`, `wget`, `vim`
  - `net-tools`, `xterm`
  - `dbus-x11`, X11 utilities
- Runs on **linux/amd64** explicitly

---

## 📦 Installed Software

- Desktop:
  - `xfce4`, `xfce4-goodies`
  - `xubuntu-icon-theme`
- VNC & Web:
  - `tigervnc-standalone-server`
  - `novnc`
  - `websockify`
- Browser:
  - `firefox` (APT version via `mozillateam` PPA)
- System:
  - `systemd`, `snapd`, `sudo`, `tzdata`

---

## 🐳 Dockerfile Overview

Key behaviors:

- Sets non-interactive APT mode
- Installs full XFCE desktop
- Configures Firefox APT pinning (avoids Snap)
- Exposes:
  - `5901` → VNC
  - `6080` → noVNC (HTTPS, self-signed cert)
- Starts:
  - VNC server **without authentication**
  - noVNC proxy with self-signed TLS cert

---

## 🚀 Build the Image

```bash
docker build -t ubuntu-xfce-vnc .
````

---

## ▶️ Run the Container

```bash
docker run -d \
  --name ubuntu-xfce \
  -p 5901:5901 \
  -p 6080:6080 \
  ubuntu-xfce-vnc
```

---

## 🌐 Access the Desktop

### Option 1: Browser (Recommended)

Open:

```
https://localhost:6080
```

* Accept the browser security warning (self-signed cert)
* You’ll see the XFCE desktop directly in your browser

### Option 2: VNC Client

Connect to:

```
localhost:5901
```

* **No password required**
* Encryption disabled

---

## 🧠 Environment Variables (Informational)

These are defined but **not enforced by Docker**:

```text
DISK_SIZE=2048G
RAM_SIZE=300G
CPU_CORES=48
```

They are informational only and do **not** limit container resources.
Use Docker flags like `--memory` or `--cpus` to enforce limits.

---

## 🔒 Security Notes (Important)

This image is intentionally insecure by design:

* ❌ No VNC authentication
* ❌ No TLS verification (self-signed cert)
* ❌ Runs as root

### If you plan to use this seriously:

* Add VNC authentication
* Use a reverse proxy (Nginx, Traefik) with real TLS
* Restrict access to localhost or VPN only
* Create and use a non-root user

---

## 🧹 Stop & Remove

```bash
docker stop ubuntu-xfce
docker rm ubuntu-xfce
```

---

## 🛠️ Use Cases

* Remote Linux GUI testing
* Browser-based Linux desktop
* CI/CD debugging with GUI tools
* Dev environments on powerful servers

---

## 📄 License

MIT (or add your preferred license)

---

## 💬 Notes

If something feels slow, adjust the VNC resolution:

```bash
-geometry 1920x1080
```

inside the `CMD` line of the Dockerfile.

Happy hacking 🧑‍💻🐧
