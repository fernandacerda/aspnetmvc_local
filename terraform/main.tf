provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_container_cluster" "primary" {
  name               = var.cluster_name
  location           = var.region
  initial_node_count = 1

  # Specify the zones within the region, excluding the one you want to leave out
  node_locations     = [var.zone]

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 40
  }

  network_policy {
    enabled = true
  }
  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }
    http_load_balancing {
      disabled = true
    }
    network_policy_config {
      disabled = false
    }
  }
}

resource "google_container_node_pool" "windows_pool" {
  name       = "windows-pool"
  cluster    = google_container_cluster.primary.name
  location   = google_container_cluster.primary.location
  node_count = 1

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 50
    image_type = "WINDOWS_LTSC"
  }
}

