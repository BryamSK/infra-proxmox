#
## 1️⃣ Levantar los contenedores

```bash
docker compose up -d
```

## 2️⃣  Acceder a GitLab
- Navegador → http://gitlab.example.com or http://<IP>
- El usuario inicial es root.
- La contraseña inicial se encuentra en:
```bash
docker exec -it gitlab grep 'Password:' /etc/gitlab/initial_root_password
```
## 3️⃣ Registrar el runner
- Ve a GitLab → Admin → Runners y copia el token de registro.
- Ejecuta:
```bash
docker exec -it gitlab-runner gitlab-runner register
```
    URL: http://gitlab.example.com or http://<IP>
    Token: el que copiaste.
    Executor: docker o shell (recomiendo docker para aislar jobs).
    Imagen por defecto: alpine:latest o la que prefieras.

## 4️⃣ Probar CI/CD
- En un proyecto nuevo, crea .gitlab-ci.yml:
```bash
stages:
  - test

test-job:
  stage: test
  script:
    - echo "Pipeline funcionando 🚀"
```
- Haz commit y push, y deberías ver que el runner ejecuta el job.


