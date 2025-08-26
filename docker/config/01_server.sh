#!/bin/bash

SERVICE="DOCKER"
COMPOSE=$(docker compose version 2>/dev/null || echo "No instalado")
DOCKER=$(docker -v 2>/dev/null || echo "No instalado")
STATS=$(docker stats --no-stream 2>/dev/null || echo "No hay contenedores en ejecución")

echo -e ""
echo -e "\033[1m🐳 Servicio: $SERVICE\033[0m"
echo -e "    🛠️    \033[33mDocker:\033[1;92m $DOCKER\033[0m"
echo -e "    📦   \033[33mDocker Compose:\033[1;92m $COMPOSE\033[0m"
echo -e ""
echo -e "\033[33m[Container List]\033[0m"
echo -e "\033[1;92m$STATS\033[0m"
echo -e ""
echo -e "\033[33m📄 Documentación:\033[1;92m https://docs.docker.com/engine/\033[0m"
echo -e ""