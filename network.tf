resource "google_compute_network" "network-basic-kevin" {
    name = "network-basic-kevin"
    auto_create_subnetworks = false
    count = local.env=="default" ? 1 : 0
}

resource "google_compute_subnetwork" "network-app-kevin"{
    name = var.network-subnetname-kevin[local.env]
    ip_cidr_range = var.network-subnet-kevin[local.env] 
    network = "network-basic-kevin"
}

variable "network-subnet-kevin"{
    default = {
       "dev" = "192.168.6.0/24"
       "qa" = "192.168.10.0/24"
       "prod" = "192.168.30.0/24"
   }
}


variable "network-subnetname-kevin" {
    default = {
        "dev" = "network-dev-kevin"
        "qa" = "network-qa-kevin"
        "prod" = "network-prod-kevin"
    }
}