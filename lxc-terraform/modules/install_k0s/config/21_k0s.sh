#!/bin/bash

SERVICE="K0S"
K0S_VERSION=$(k0s version 2>/dev/null || echo "No instalado")
K0S_STATUS=$(systemctl is-active k0scontroller 2>/dev/null || systemctl is-active k0sworker 2>/dev/null || echo "No activo")
ROLE=$(if systemctl is-active k0scontroller &>/dev/null; then echo "Controller"; elif systemctl is-active k0sworker &>/dev/null; then echo "Worker"; else echo "Desconocido"; fi)
NODE_NAME=$(hostname)
IP=$(hostname -I | awk '{print $1}')
KUBE_NODES=$(k0s kubectl get nodes -o wide 2>/dev/null | grep -v NAME | wc -l)
KUBE_PODS=$(k0s kubectl get pods -A 2>/dev/null | grep -v NAME | wc -l)
CPU=$(lscpu | grep "Model name" | cut -d ':' -f2 | xargs)
MEMORY=$(free -h | awk '/Mem:/ {print $3 " / " $2}')
DISK=$(df -h / | awk 'NR==2 {print $3 " / " $2}')

echo -e ""
echo -e "\033[1m☸️  Servicio: $SERVICE\033[0m"
echo -e "    🏷️  \033[33mRol del nodo:\033[1;92m $ROLE\033[0m"
echo -e "    🧩  \033[33mVersión:\033[1;92m $K0S_VERSION\033[0m"
echo -e "    🚦  \033[33mEstado del servicio:\033[1;92m $K0S_STATUS\033[0m"
echo -e "    🖧  \033[33mIP:\033[1;92m $IP\033[0m"
echo -e "    💻  \033[33mNodo:\033[1;92m $NODE_NAME\033[0m"
echo -e ""
echo -e "\033[33m[Kubernetes Cluster Info]\033[0m"
echo -e "    🧱  \033[33mNodos activos:\033[1;92m $KUBE_NODES\033[0m"
echo -e "    📦  \033[33mPods totales:\033[1;92m $KUBE_PODS\033[0m"
echo -e ""
echo -e "\033[33m[Recursos del sistema]\033[0m"
echo -e "    🖥️  \033[33mCPU:\033[1;92m $CPU\033[0m"
echo -e "    💾  \033[33mRAM:\033[1;92m $MEMORY\033[0m"
echo -e "    🗄️  \033[33mDisco (/):\033[1;92m $DISK\033[0m"
echo -e ""
echo -e "\033[33m📄 Documentación K0s:\033[1;92m https://docs.k0sproject.io/latest/\033[0m"
echo -e ""