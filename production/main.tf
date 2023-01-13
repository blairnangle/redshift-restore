variable "admin_password" {}
variable "production_aws_account_number" {}
variable "my_ip" {}

module "redshift" {
  source                        = "../redshift"
  snapshot_identifier           = null
  production_aws_account_number = var.production_aws_account_number
  admin_password                = var.admin_password
  my_ip                         = var.my_ip
}

output "cluster_endpoint_host" {
  value = split(":", module.redshift.cluster_endpoint)[0]
}
