output "k0s_summary" {
  description = "Resumen completo de la instalación y configuración de K0s en el nodo remoto"
  value = {
    node_info = {
      host       = var.host
      user       = var.user
      ip_address = var.host
    }

    install = {
      status  = "Instalación completada en ${var.host} para el usuario ${var.user}"
      version = trimspace(
        chomp(
          replace(
            join("", [
              "k0s version 2>/dev/null || echo 'Desconocido'"
            ]),
            "\n",
            ""
          )
        )
      )
    }

    cluster = {
      controller = var.host
      addons     = ["metallb"]
      status     = "K0s Controller iniciado con MetalLB configurado"
    }
  }
}