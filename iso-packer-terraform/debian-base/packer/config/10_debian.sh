#!/bin/bash

SERVICE="DEBIAN"
OS=$(lsb_release -ds 2>/dev/null || cat /etc/debian_version)
KERNEL=$(uname -r)
UPTIME=$(uptime -p)
CPU=$(lscpu | grep "Model name" | cut -d ':' -f2 | xargs)
MEMORY=$(free -h | awk '/Mem:/ {print $3 " / " $2}')
DISK=$(df -h / | awk 'NR==2 {print $3 " / " $2}')
IP=$(hostname -I | awk '{print $1}')
HOSTNAME=$(hostname)

echo -e ""
echo -e "\033[1m🖥️  Sistema: $SERVICE\033[0m"
echo -e "    🏷️  \033[33mHostname:\033[1;92m $HOSTNAME\033[0m"
echo -e "    📦  \033[33mOS:\033[1;92m $OS\033[0m"
echo -e "    🖧  \033[33mIP:\033[1;92m $IP\033[0m"
echo -e "    🧬  \033[33mKernel:\033[1;92m $KERNEL\033[0m"
echo -e "    ⏱️  \033[33mUptime:\033[1;92m $UPTIME\033[0m"
echo -e "    🖥️  \033[33mCPU:\033[1;92m $CPU\033[0m"
echo -e "    💾  \033[33mRAM:\033[1;92m $MEMORY\033[0m"
echo -e "    🗄️  \033[33mDisco (/):\033[1;92m $DISK\033[0m"
echo -e ""
echo -e "\033[33m📄 Documentación Debian:\033[1;92m https://www.debian.org/doc/\033[0m"
echo -e ""