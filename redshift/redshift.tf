variable "admin_password" {}
variable "snapshot_identifier" {}
variable "production_aws_account_number" {}

resource "aws_redshift_cluster" "my_cluster" {
  cluster_identifier        = "my-cluster"
  master_username           = "redshiftadmin"
  master_password           = var.admin_password
  node_type                 = "dc2.large"
  cluster_type              = "single-node"
  port                      = "5439"
  number_of_nodes           = 1
  skip_final_snapshot       = true
  publicly_accessible       = true
  apply_immediately         = true
  snapshot_identifier       = var.snapshot_identifier
  owner_account             = var.production_aws_account_number
  cluster_subnet_group_name = aws_redshift_subnet_group.my_cluster.name
}

output "cluster_endpoint" {
  value = aws_redshift_cluster.my_cluster.endpoint
}
