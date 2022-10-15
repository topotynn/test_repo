variable "project_id" {
  default     = "mogo-dev"
  type        = string
  description = "The project ID to host the cluster in"
}

variable "region" {
  type        = string
  description = "The region to host the cluster in"
  default     = "europe-west3"
}

variable "zone" {
  type        = string
  description = "The zone to host the cluster in"
  default     = "europe-west3-a"
}

#Network
variable "vpc_range" {
  default     = "10.10.4.0/23"
  description = "#TODO"
}

variable "vpc_subnetwork_pods_range" {
#  default     = "10.100.0.0/14"
  default     = "172.16.0.0/16"
  description = "the range for pods"
}

variable "vpc_subnetwork_services_range" {
# default     = "10.104.0.0/20"
  default     = "172.17.0.0/16"
  description = "the range for services"
}

variable "vpc_subnetwork_master_range" {
  default     = "192.168.0.0/28"
  description = "the range for services"
}

# GKE
variable "cluster_name" {
  default     = "mogo-dev"
  description = "GKE cluster name"
}

variable "gke_num_nodes" {
  default     = 1
  description = "The number of nodes per instance group"
}

variable "gke_machine_type_app" {
  default     = "e2-small"
  description = "The machine type to create"
}

variable "gke_machine_type_mongodb" {
  default     = "e2-small"
  description = "The machine type to create"
}

variable "k8s_master_ipv4_cidr_block" {
  default     = ""
  description = "#TODO"
}

variable "disk_size" {
  default     = 20
  description = " The size of the image in gigabytes"
}

variable "namespace" {
  default     = "nginx"
  description = "Namespace for apps"
}

variable "docker_config_path" {
  default     = "./config.json"
  description = "Path to the docker config"
}
