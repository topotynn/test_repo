provider "google" {
  project = "mogo-dev"
  region = var.region
  zone = var.zone
}

provider "helm" {
  kubernetes {
    host     = "https://${google_container_cluster.mogo_dev_tf.endpoint}"

    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = "${base64decode(google_container_cluster.mogo_dev_tf.master_auth.0.cluster_ca_certificate )}"
  }
}

provider "kubernetes" {
    host     = "https://${google_container_cluster.mogo_dev_tf.endpoint}"

    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = "${base64decode(google_container_cluster.mogo_dev_tf.master_auth.0.cluster_ca_certificate )}"
}

data "google_client_config" "default" {}
