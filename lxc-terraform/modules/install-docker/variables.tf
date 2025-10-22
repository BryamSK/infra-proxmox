variable "host" {
  description = "IP o hostname del LXC"
  type        = string
}
variable "user" {
  description = "Usuario para SSH"
  type        = string
}
variable "private_key_path" {
  description = "Ruta a la clave privada para SSH"
  type        = string
}