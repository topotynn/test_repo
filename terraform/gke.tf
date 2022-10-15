# GKE cluster
resource "google_container_cluster" "mogo_dev_tf" {
  name     = "${var.project_id}-tf-cluster"
  location = var.zone

  remove_default_node_pool = true
  initial_node_count       = 1

  network = google_compute_network.vpc-network.id
  subnetwork = google_compute_subnetwork.vpc-sub-network.id

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.vpc_subnetwork_master_range

    master_global_access_config {
      enabled = true
    }
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = var.vpc_subnetwork_pods_range
    services_ipv4_cidr_block = var.vpc_subnetwork_services_range
  }

  lifecycle {
    ignore_changes = [
      maintenance_policy
    ]
  }

  depends_on = [
    google_compute_network.vpc-network,
    google_compute_subnetwork.vpc-sub-network
  ]
}

# Separately Managed Node Pool
resource "google_container_node_pool" "app_pool" {
  name       = "${google_container_cluster.mogo_dev_tf.name}-app-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.mogo_dev_tf.name
  node_count = var.gke_num_nodes
  autoscaling {
    max_node_count = 3
    min_node_count = 1
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      env = var.project_id
      type = "app"
    }

    # preemptible  = true
    machine_type = var.gke_machine_type_app
    disk_size_gb = var.disk_size
    disk_type    = "pd-ssd"
    tags         = ["gke-node", var.cluster_name]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  lifecycle {
    ignore_changes = [
      autoscaling
    ]
  }

  depends_on = [
    google_compute_network.vpc-network,
    google_compute_subnetwork.vpc-sub-network,
    google_container_cluster.mogo_dev_tf
  ]
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.mogo_dev_tf.name
  description = "GKE Cluster Name"
}
