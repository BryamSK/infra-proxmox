#!/bin/bash
set -euo pipefail

# Colores para mensajes
INFO="\033[1;34m[INFO]\033[0m"
ERROR="\033[1;31m[ERROR]\033[0m"
START_TIME=$(date +%s)

log() {
  echo -e "$INFO $1"
}

fail() {
  echo -e "$ERROR $1"
  exit 1
}

is_installed() {
  command -v "$1" >/dev/null 2>&1
}

# Verifica si está ejecutado como root
if [ "$EUID" -ne 0 ]; then
  fail "Este script debe ejecutarse con permisos de superusuario (sudo)."
fi

while sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
    echo "Esperando a que apt esté disponible..."
    sleep 5
done

log "Actualizando el sistema..."
apt-get update && apt-get upgrade -y
	apt-get install -y ca-certificates curl gnupg lsb-release git net-tools

########################################
# Docker
########################################
if is_installed docker; then
	echo "Docker Installed."
else
	log "Instalando Docker..."
	for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

		## Add Docker's official GPG key:
	apt-get update
	install -m 0755 -d /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
	chmod a+r /etc/apt/keyrings/docker.asc

			## Add the repository to Apt sources:
	echo \
	"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
	$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
	sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

	docker --version
	docker compose version

	systemctl enable docker && systemctl start docker

	log "Docker instalado correctamente."
fi
########################################
apt autoremove -y && apt clean
log "🔎 Verificando versiones instaladas:"
echo ""
log "Docker versión: $(docker --version || echo 'No disponible')"
END_TIME=$(date +%s)
log "⏱ Tiempo total de ejecución: $((END_TIME - START_TIME)) segundos."