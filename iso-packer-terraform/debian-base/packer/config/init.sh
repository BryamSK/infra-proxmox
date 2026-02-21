#!/usr/bin/env bash
set -euxo pipefail
export DEBIAN_FRONTEND=noninteractive
export DPKG_OPTIONS="--force-confdef --force-confold"

# Variables (puedes ajustar por defecto)
DNS_SERVERS="${DNS_SERVERS:-8.8.8.8 8.8.4.4}"
SEARCHDOMAIN="${SEARCHDOMAIN:-}"

# Paquetes necesarios
apt update -y && apt upgrade -y && apt dist-upgrade -y
apt-get install -y cloud-init cloud-guest-utils qemu-guest-agent systemd-resolved vim curl ca-certificates parted
apt-get autoremove -y && apt-get clean -y

# Habilitar servicios
systemctl enable --now qemu-guest-agent
systemctl enable --now systemd-resolved

# Usar systemd-resolved para /etc/resolv.conf
ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf

# Evitar que dhcpcd (si existe) toque resolv.conf
if [ -f /etc/dhcpcd.conf ]; then
  grep -q '^nohook resolv.conf' /etc/dhcpcd.conf || echo 'nohook resolv.conf' >> /etc/dhcpcd.conf
  systemctl disable --now dhcpcd || true
fi

# Config por defecto de systemd-resolved (Terraform/Cloud-init aplicarán DNS finales)
mkdir -p /etc/systemd
{
  echo "[Resolve]"
  echo "DNS=${DNS_SERVERS}"
  [ -n "${SEARCHDOMAIN}" ] && echo "Domains=${SEARCHDOMAIN}" || true
} > /etc/systemd/resolved.conf
systemctl restart systemd-resolved || true

# Limpiar interfaces para usar cloud-init
cat /dev/null > /etc/network/interfaces
echo 'source /etc/network/interfaces.d/*' >> /etc/network/interfaces

mkdir -p /root/.ssh
chmod 700 /root/.ssh
cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
chown root:root /root/.ssh/authorized_keys
echo 'set mouse-=a' >> /root/.vimrc
cat /tmp/10_debian.sh >> /etc/profile.d/10_debian.sh
chmod +x /etc/profile.d/10_debian.sh
mkdir -p /etc/cloud/cloud.cfg.d
cat /tmp/99-custom.cfg >> /etc/cloud/cloud.cfg.d/99-custom.cfg
apt update -y && apt upgrade -y && apt dist-upgrade -y
cloud-init clean

######
echo "Template preparado. Apaga la VM y conviértela en template."