resource "google_compute_firewall" "firewall-nginx-kevin" {
  name="firewall-nginx-kevin"
  network="network-basic-kevin"

  allow {
      protocol = "tcp"
      ports = ["22","80"]
  }
  source_ranges = ["0.0.0.0/0"]
}