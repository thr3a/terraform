variable "root_password" {
  description = "root default password"
  type        = string
}

resource "linode_instance" "main" {
  label  = "gpu01"
  image  = "linode/ubuntu22.04"
  region = "jp-osa"
  # 1番小さいモデル
  # type             = "g6-nanode-1"
  type             = "g1-gpu-rtx4000a-2"
  authorized_users = ["thr3a"]
  backups_enabled  = false
  booted           = true
  private_ip       = false
  # root_pass        = random_password

  metadata {
    user_data = base64encode(file("cloud-config.yml"))
  }
}

# resource "random_string" "password" {
#   length  = 12
#   special = false
#   upper   = true
#   lower   = true
# }
# output "random_password" {
#   value     = random_string.password.result
#   sensitive = false
# }

