resource "google_compute_instance" "nginx-kevin" {
    name = element( var.nginx-name[local.env] , count.index)
    zone = "asia-southeast1-${element(var.suffix-nginx[local.env], count.index)}"
    machine_type = "custom-2-2048"
    count = length(var.nginx-name[local.env])
    network_interface {
        subnetwork = google_compute_subnetwork.network-app-kevin.self_link
        subnetwork_project = "infra-lab-224809"
        access_config {}
    }
    
    boot_disk{
        initialize_params {
            size = "20"
            type = "pd-standard"
            image = var.nginx-boot-disk-image
        }

    }

}

variable "nginx-name" {
  default  = {
      "qa" = ["nginx-0-kevin-qa", "nginx-1-kevin-qa"]
      "dev" = ["nginx-0-kevin-dev"]
      "prod"= ["nginx-0-kevin-prod","nginx-1-kevin-prod","nginx-2-kevin-prod"]
  }     
}

variable "nginx_specs" {
    default =  {
        "qa" = ["custom-2-4096","custom-2-4096"]
        "dev" = ["custom-1-1024"]
        "prod" = ["custom-4-8192","custom-4-8192","custom-4-8192"]
    }
}

variable "suffix-nginx"{
    default = {
        "qa" = ["a","b"]
        "dev" = ["a"]
        "prod" = ["a","a","a"]
    }
}

variable "nginx-boot-disk-image"{
    type = string
    default = "centos-7-v20190813"
}

locals {
    env = terraform.workspace
}
