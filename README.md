# 🛠️ Infraestructura Setup Script para Debian

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

## 🚀 Uso

```bash
git clone https://tu-repo.git
cd tu-repo
chmod +x setup_infra.sh
sudo ./setup_infra.sh


packer plugins install github.com/hashicorp/ansible
packer plugins install github.com/hashicorp/proxmox