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

log "Actualizando el sistema..."
apt update && apt upgrade -y
	apt install -y ca-certificates curl gnupg lsb-release git zsh wget zip htop net-tools

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
	apt-get update && apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

	docker --version
	docker compose version

	systemctl enable docker && systemctl start docker

	log "Docker instalado correctamente."
fi
########################################
# Terraform & Packer (HashiCorp)
########################################
install_hashicorp_repo() {
  if [ ! -f /usr/share/keyrings/hashicorp-archive-keyring.gpg ]; then
    log "Agregando repositorio de HashiCorp..."
    curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
    apt update
  fi
}
	# Determinar si necesitamos añadir el repo
NEED_HASHICORP_REPO=false
if ! is_installed terraform; then
  NEED_HASHICORP_REPO=true
else
  echo "terraform Installed."
fi

if ! is_installed packer; then
  NEED_HASHICORP_REPO=true
else
  echo "packer Installed."
fi
if [ "$NEED_HASHICORP_REPO" = true ]; then
  install_hashicorp_repo
fi

	#Instalar los que faltan
if ! is_installed terraform; then
  apt install -y terraform
fi

if ! is_installed packer; then
  apt install -y packer
fi
########################################
# Ansible
########################################
if is_installed ansible; then
	echo "Ansible Installed."
else
	log "Instalando ansible"
	apt install -y ansible 
fi
########################################
# AWS CLI v2
########################################
if is_installed aws; then
	echo "AWS CLI Installed."
else
	log "Instalando AWS CLI v2..."

	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	unzip awscliv2.zip
	sudo ./aws/install
	rm -rf aws awscliv2.zip
fi

########################################
# Python
########################################
if is_installed python; then
	echo "python Installed"
else
	log "Instalando Python"
	apt install -y python3 python3-pip python-is-python3
fi

########################################
# kubectl
########################################
if is_installed kubectl; then
	echo "kubectl Installed"
else
	log "Instalando kubectl..."
	curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
	sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
fi

########################################
# gitlab-ci-local
########################################
if is_installed gitlab-ci-local; then
	echo "gitlab-ci-local Installed"
else
	wget -O /etc/apt/sources.list.d/gitlab-ci-local.sources https://gitlab-ci-local-ppa.firecow.dk/gitlab-ci-local.sources
	apt-get update
	apt-get install gitlab-ci-local
fi

########################################
# Fin
########################################
apt autoremove -y && apt clean
log "🔎 Verificando versiones instaladas:"
echo ""
log "Docker versión: $(docker --version || echo 'No disponible')"
log "Terraform versión: $(terraform version | head -n 1 || echo 'No disponible')"
log "Packer versión: $(packer -version || echo 'No disponible')"
log "Ansible versión: $(ansible --version | head -n 1 || echo 'No disponible')"
log "AWS CLI versión: $(aws --version || echo 'No disponible')"
log "Python versión: $(python --version || echo 'No disponible')"
log "pip3 versión: $(pip3 --version || echo 'No disponible')"
log "kubectl versión: $(kubectl version --client | grep Client || echo 'No disponible')"
log "gitlab-ci-local versión: $(gitlab-ci-local --version || echo 'No disponible')"
log "✅ Ambiente de infraestructura instalado correctamente."
log "Reinicia la terminal o ejecuta 'source /etc/profile' para actualizar variables como PATH."
END_TIME=$(date +%s)
log "⏱ Tiempo total de ejecución: $((END_TIME - START_TIME)) segundos."
