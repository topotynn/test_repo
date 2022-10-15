resource "google_compute_network" "vpc-network" {
  name                    = "${var.project_id}-tf-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc-sub-network" {
  name                     = "${var.project_id}-tf-net-subnetwork"
  ip_cidr_range            = var.vpc_range
  region                   = var.region
  network                  = google_compute_network.vpc-network.id
  private_ip_google_access = true
}

resource "google_compute_router" "router" {
  project = var.project_id
  name    = "nat-router"
  network = google_compute_network.vpc-network.id
  region  = var.region
  depends_on = [
    google_compute_subnetwork.vpc-sub-network
  ]
}

resource "google_compute_router_nat" "nat" {
  name                               = "nat-config"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
  depends_on = [
    google_compute_router.router
  ]
}

resource "google_compute_firewall" "ssh-access" {
  name    = "${var.project_id}-tf-ssh-access"
  project = var.project_id
  network = google_compute_network.vpc-network.id

  allow {
    protocol = "tcp"
    ports    = [22]
  }

  #TODO should this be configurable ?
  source_ranges = ["62.80.191.137/32"]

  depends_on = [
    google_compute_network.vpc-network,
    google_compute_subnetwork.vpc-sub-network
  ]
}
