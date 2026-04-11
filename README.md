# Real-Time WebSocket Application Deployment (DevOps Project)

## Project Overview

This project demonstrates the deployment of a real-time WebSocket-based chat application using DevOps setup. The goal is to debug a misconfigured containerized application, fix infrastructure issues, and deploy it on a cloud environment with CI/CD automation.

---

##  Architecture Diagram

```
User Browser
     ↓
Public IP (EC2 Instance)
     ↓
NGINX (Reverse Proxy - Docker Container)
     ↓
Backend WebSocket Application (Docker Container)
```


## Docker Setup

### Containers:

* **Backend Container**

  * Runs WebSocket server
  * Exposed on internal port (e.g., 3000)

* **NGINX Container**

  * Acts as reverse proxy
  * Routes HTTP + WebSocket traffic

### Key Features:

* Multi-container setup using `docker-compose`
* Automatic restart policy (`restart: always`)
* Internal Docker networking using service names

---

## Docker Networking

* Both containers are connected via a custom Docker network
* Communication happens using service names:

  * Example: `http://backend:3000`
* Avoided `localhost` to ensure proper inter-container communication

---

## NGINX Reverse Proxy Configuration

NGINX is configured to:

* Serve frontend files
* Route API/WebSocket requests to backend container
* Handle WebSocket upgrade headers

---

## WebSocket Handling

WebSocket communication requires:

* HTTP/1.1 protocol
* Upgrade headers (`Upgrade`, `Connection`)
* Persistent connection handling via NGINX

This was fixed to enable **real-time multi-user chat across browser tabs**.

---

## Cloud Deployment (AWS EC2)

### Steps:

1. Launched EC2 instance (t3.micro)
2. Installed Docker & Docker Compose
3. Deployed application using:

```bash
docker compose up -d --build
```

### Live Application:

```
http://100.53.15.151
```

---

## CI/CD Pipeline (GitHub Actions)

Automated deployment pipeline:

### Workflow:

1. Triggered on every push to `main`
2. Connects to EC2 via SSH
3. Pulls latest code
4. Rebuilds Docker containers
5. Restarts application


## Issues Identified & Fixes

| Issue                        | Root Cause                       | Fix                                           |
| ---------------------------- | -------------------------------- | --------------------------------------------- |
| Docker permission denied     | User not in docker group         | Added user to docker group & reloaded session |
| Containers not communicating | Wrong host (`localhost`) used    | Replaced with service name (`backend`)        |
| WebSocket not working        | Missing upgrade headers in NGINX | Added required headers                        |
| NGINX routing failure        | Incorrect proxy configuration    | Fixed `proxy_pass` and routing                |
| Deployment not automated     | Missing CI/CD                    | Implemented GitHub Actions                    |

---

##  Project Structure

```
devops/
 ├── Dockerfile
 ├── docker-compose.yml
 ├── nginx.conf
 ├── README.md
 └── .github/workflows/deploy.yml
```

---

we can see the UI and able to open multiple browser tabs at http://100.53.15.151 to chat back and forth in real-time