resource "null_resource" "install_k0s" {
  provisioner "file" {
    source      = "./../modules/install_k0s/config/21_k0s.sh"
    destination = "/etc/profile.d/21_k0s.sh"
    connection {
      type        = "ssh"
      host        = var.host
      user        = var.user
      private_key = file(var.private_key_path)
    }
  }

  provisioner "file" {
    source      = "./../modules/install_k0s/config/metallb-config.yaml"
    destination = "/tmp/metallb-config.yaml"
    connection {
      type        = "ssh"
      host        = var.host
      user        = var.user
      private_key = file(var.private_key_path)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "set -eux",
      "export DEBIAN_FRONTEND=noninteractive",
      "apt install -y curl",
      "curl --proto '=https' --tlsv1.2 -sSf https://get.k0s.sh | sh",
      "k0s install controller --single",
      "systemctl daemon-reload",
      "systemctl enable k0scontroller",
      "systemctl start k0scontroller",
      "sleep 20",
      "k0s kubeconfig admin > kubeconfig",
      "mv /tmp/metallb-config.yaml .",
      "k0s kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.12/config/manifests/metallb-native.yaml",
      "k0s kubectl wait -n metallb-system --for=condition=Available deployment/controller --timeout=200s",
      "k0s kubectl wait -n metallb-system --for=condition=Available deployment/speaker --timeout=200s",
      "sleep 40",
      "k0s kubectl apply -f metallb-config.yaml",
    ] 
    connection {
      type        = "ssh"
      host        = var.host
      user        = var.user
      private_key = file(var.private_key_path)
    }
  }
}
