This repo contains terraform code to create kubernetes objects like deployment , service and ingress objects in gke cluster which can be run by applying this terraform as start up script in bastion host vm .
This repo contains main.tf and variables.tf file and we need to create terraform.tfvars file before applying the terraform and its sample is as follows
project = "<project-id>"
path_to_json = "<path-to-service-account-file>"
image_name= "<image-name>"

Also make sure that service account used for terraform has required permissions to create secrets, access gke cluster etc .
