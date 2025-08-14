# 📦 Imágenes Base Debian para Proxmox

Este módulo contiene la configuración de Packer y Terraform para construir imágenes base de Debian (12 y 13) listas para ser usadas en Proxmox.

## 🚀 ¿Qué incluye?

- Archivos Packer (`.pkr.hcl`) para automatizar la creación de imágenes.
- Configuraciones de preseed y customización en `config/`.
- Módulo Terraform para importar y gestionar las imágenes en Proxmox.

## 📝 Uso

1. **Configura tus variables:**
   - Copia y edita `variables.auto.pkrvars.hcl.example` y `terraform/terraform.tfvars.example`.

2. **Construye la imagen con Packer:**
   ```bash
   packer init .
      #Para Desplegar las dos imagenes en todos los nodos
   packer build .
      #Para Seleccionar el Despliegue
   packer build -only=proxmox-iso.debian12-n1 .
   ```

3. **Gestiona la imagen con Terraform:**
   ```bash
   cd terraform
   terraform init
   terraform apply
   ```

## 📁 Estructura

- `debian12.pkr.hcl`, `debian13.pkr.hcl`: Definiciones de imágenes.
- `config/`: Archivos de configuración y preseed.
- `terraform/`: Código para importar y gestionar imágenes en Proxmox.

## ℹ️ Notas

- Requiere plugins de Packer y el provider de Proxmox para Terraform.
- Consulta los archivos `.example` para personalizar tu despliegue.