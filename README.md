# 🛠️ Infraestructura Setup Script para Debian

Este script automatiza la instalación de herramientas esenciales de infraestructura sobre sistemas Debian. Incluye Docker, Terraform, Packer, Ansible, AWS CLI, Python, Go, kubectl y gitlab-ci-local.

---

## 📦 Herramientas instaladas

- [Docker](https://www.docker.com/)
- [Terraform](https://developer.hashicorp.com/terraform)
- [Packer](https://developer.hashicorp.com/packer)
- [Ansible](https://www.ansible.com/)
- [AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- [Python 3 + pip](https://www.python.org/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [gitlab-ci-local](https://gitlab.com/firecow/gitlab-ci-local)

---

## ✅ Requisitos

- Debian 11 o superior
- Acceso a `sudo`
- Conexión a internet
- Tener permisos de superusuario

---

## 🚀 Uso

```bash
git clone https://tu-repo.git
cd tu-repo
chmod +x setup_infra.sh
sudo ./setup_infra.sh


packer plugins install github.com/hashicorp/ansible
packer plugins install github.com/hashicorp/proxmox