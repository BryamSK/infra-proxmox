#!/bin/bash
# =========================================================
# Script para configurar un servidor Debian:
# 1. Instala herramientas esenciales.
# 2. Desactiva suspensión e hibernación.
# 3. Agrega alias y función lxcs al .bashrc (usuario y root).
# 4. Añade registros al /etc/hosts.
# =========================================================

CONF_FILE="/etc/systemd/logind.conf"
BASHRC_USER="$HOME/.bashrc"
BASHRC_ROOT="/root/.bashrc"
HOSTS_FILE="/etc/hosts"

# Verificar permisos
if [ "$EUID" -ne 0 ]; then
  echo "⚠️  Este script debe ejecutarse como root o con sudo."
  exit 1
fi

echo "🛠  Iniciando configuración del sistema..."

# =========================================================
# 1️⃣ Instalar paquetes útiles
# =========================================================
echo "📦 Instalando herramientas básicas..."
truncate -s 0 /etc/issue && truncate -s 0 /etc/issue.net && truncate -s 0 /etc/motd
chmod -x /etc/update-motd.d/*
apt update -y
apt install -y vim curl wget htop net-tools iperf3
echo "set mouse-=a" >> ~/.vimrc

if [ $? -eq 0 ]; then
  echo "✅ Paquetes instalados correctamente."
else
  echo "❌ Error al instalar paquetes. Revisa tu conexión o repositorios."
  exit 1
fi

# =========================================================
# 2️⃣ Configurar logind.conf para evitar suspensión
# =========================================================
echo "⚙️  Configurando $CONF_FILE ..."

cp "$CONF_FILE" "${CONF_FILE}.bak_$(date +%F_%H-%M-%S)"

set_config() {
  local key="$1"
  local value="$2"
  if grep -q "^$key=" "$CONF_FILE"; then
    sed -i "s|^$key=.*|$key=$value|" "$CONF_FILE"
  else
    echo "$key=$value" >> "$CONF_FILE"
  fi
}

set_config "HandleLidSwitch" "ignore"
set_config "HandleLidSwitchDocked" "ignore"
set_config "HandleSuspendKey" "ignore"
set_config "HandleHibernateKey" "ignore"
set_config "IdleAction" "ignore"
set_config "IdleActionSec" "0"

systemctl restart systemd-logind
echo "✅ Configuración de suspensión actualizada."

# =========================================================
# 3️⃣ Añadir alias y función lxcs al .bashrc
# =========================================================
echo "🔧 Configurando alias y función LXCS en .bashrc..."

BASH_BLOCK=$(cat <<'EOF'

# ==== Alias básicos ====
alias ls='ls --color=auto'
alias ll='ls -l --color=auto'
alias l='ls -lA --color=auto'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias update="apt update -y && apt upgrade -y && apt dist-upgrade -y"

###
#Scripts LXE
lxcs() {
    local script_name="$1"
    local base_url="https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct"

    if [ -z "$script_name" ]; then
        echo "Uso: LXCS <nombre_script>"
        echo "Ejemplo: LXCS debian"
        return 1
    fi

    echo "Descargando y ejecutando: ${script_name}.sh"
    bash -c "$(curl -fsSL ${base_url}/${script_name}.sh)" || {
        echo "Error: No se pudo descargar o ejecutar ${script_name}.sh"
        return 1
    }
}
###
EOF
)

add_bash_block() {
  local target_file="$1"
  if ! grep -q "lxcs()" "$target_file" 2>/dev/null; then
    echo "$BASH_BLOCK" >> "$target_file"
    echo "✅ Bloque agregado a $target_file"
  else
    echo "ℹ️  Alias y función ya existen en $target_file, se omitió."
  fi
}

add_bash_block "$BASHRC_USER"
add_bash_block "$BASHRC_ROOT"

echo "✅ Alias y función LXCS configurados correctamente."

# =========================================================
# 4️⃣ Agregar registros al /etc/hosts
# =========================================================
echo "🗂  Configurando /etc/hosts ..."

HOST_ENTRIES=(
  "192.168.99.7 node1.local node1"
  "192.168.99.8 nas.local nas"
)

for entry in "${HOST_ENTRIES[@]}"; do
  if grep -q "$(echo "$entry" | awk '{print $2}')" "$HOSTS_FILE"; then
    echo "ℹ️  Entrada ya existe: $entry"
  else
    echo "$entry" >> "$HOSTS_FILE"
    echo "✅ Agregada: $entry"
  fi
done

# =========================================================
# 5️⃣ Finalización
# =========================================================
echo ""
echo "🎉 Configuración completa:"
echo " - Suspensión y cierre de tapa desactivados"
echo " - Paquetes esenciales instalados"
echo " - Alias y función lxcs añadidos a .bashrc (usuario y root)"
echo " - Entradas añadidas al /etc/hosts"
echo ""
echo "💡 Ejecuta 'source ~/.bashrc' para aplicar los cambios inmediatos."
