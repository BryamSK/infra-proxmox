# 🛠️ Infraestructura para DEVSEGOPS Engeniere con Proxmox

The purpose of this repository is to implement an infrastructure environment tailored for DevSecOps engineers, using Proxmox as the virtualization platform and applying Infrastructure as Code practices.

El propósito de este repositorio es implementar un entorno de infraestructura orientado a ingenieros DevSecOps, empleando Proxmox como plataforma de virtualización y aplicando prácticas de Infraestructura como Código.

---
## 📦 Herramientas Instaladas

- [Docker](https://www.docker.com/)
- [Terraform](https://developer.hashicorp.com/terraform)
- [Packer](https://developer.hashicorp.com/packer)
- [Ansible](https://www.ansible.com/)
- [AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- [Python 3 + pip](https://www.python.org/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [GitLab CE](https://docs.gitlab.com/)
- [gitlab-ci-local](https://gitlab.com/firecow/gitlab-ci-local)
- [Docker Registry privado](registry/README.md)


---

## ✅ Requisitos

- Debian 11 o superior
- Acceso a `sudo`
- Conexión a internet
- Tener permisos de superusuario

---
## 📂 Estructura del Proyecto

```
.
├── debian-base/      # Packer y Terraform para imágenes base Debian
├── docker/           # Infraestructura Docker sobre Proxmox
├── gitlab/           # GitLab CE y runner en contenedores
├── k0s/              # Cluster Kubernetes k0s sobre Proxmox
├── registry/         # Docker Registry privado
├── scripts/          # Scripts de automatización
└── README.md
```
## 🚀 Instalación Rápida

1. **Clona el repositorio:**
   ```bash
   git clone https://tu-repo.git
   cd tu-repo
   ```

2. **Instala el stack base en tu host:**
   ```bash
   chmod +x scripts/infra_stack_install.sh
   sudo ./scripts/infra_stack_install.sh
   ```

3. **Instala plugins de Packer:**
   ```bash
   packer plugins install github.com/hashicorp/ansible
   packer plugins install github.com/hashicorp/proxmox
   ```

---
## ⚙️ Despliegue de Infraestructura

Cada subdirectorio contiene su propio README y ejemplos de variables para personalizar tu despliegue:

- **Imágenes base Debian:** [debian-base/](debian-base/)
- **VM Docker:** [docker/](docker/)
- **Cluster k0s:** [k0s/](k0s/)
- **GitLab y runner:** [gitlab/](gitlab/)
- **Docker Registry:** [registry/](registry/)

Consulta los archivos `terraform.tfvars.example` y `variables.auto.pkrvars.hcl.example` en cada módulo para configurar tus credenciales y parámetros.

---

## 📝 Notas

- Los archivos sensibles y estados (`*.tfstate`, claves, etc.) están excluidos por [.gitignore](.gitignore).
- Para más detalles sobre cada componente, revisa los README de cada subcarpeta.

---

## 📚 Créditos

Inspirado en prácticas modernas de DevSecOps y automatización de infraestructura.