# Docker Private Registry con Autenticación

Este proyecto despliega un **Docker Registry privado** utilizando `docker-compose` con autenticación por usuario/contraseña.

## ✅ Requisitos

-🛠️   Docker: Docker version 28.3.3, build 980b856
-📦   Docker Compose: Docker Compose version v2.39.1

## 🚀 Despliegue
### 📂 Estructura del proyecto

```bash
mkdir -p registry auth /registry
```

├── docker-compose.yml # Definición de servicios

├── auth/ # Archivos de autenticación (htpasswd)

└── /registry # Almacenamiento persistente de imágenes

```bash
mkdir -p registry auth /registry
```

### 🔐 Genrar Credenciales
```bash
docker run --rm --entrypoint htpasswd httpd:2 -Bbn usuario password > auth/htpasswd
```
    usuario → nombre de usuario que usarás para autenticarte.
    password → contraseña del usuario.

### 🏃 Run
```bash
docker-compose up -d
```

## 🚀 Uso 

En el Host agrega el siguiente archivo
```bash
vim /etc/docker/daemon.json

{
    "insecure-registries": ["<IP>:5000"]
}

```
```bash
sudo systemctl restart docker
docker login <IP>:5000
```
-Descargar una imagen desde Docker Hub:
```bash
docker pull alpine:latest
```
-Etiquetarla para tu registry:
```bash
docker tag alpine:latest <IP>:5000/alpine:latest
```
-Subirla:
```bash
docker push <IP>:5000/alpine:latest
```

## ⬇️ Descarga Una imagen
```bash
docker pull <IP>:5000/alpine:latest
```