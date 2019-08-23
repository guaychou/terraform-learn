resource "google_compute_instance_group" "nginx-server-kevin" {
  name = "nginx-servers-kevin"
  instances = [
    google_compute_instance.nginx-kevin.0.self_link,
    google_compute_instance.nginx-kevin.2.self_link
  ]

  named_port {
      name = "http"
      port = "80"
  }

  zone = "asia-southeast1-a"
}

resource "google_compute_backend_service" "nginx-service-kevin" {
  name      = "nginx-service-kevin"
  port_name = "http"
  protocol  = "HTTP"

  backend {
    group = "${google_compute_instance_group.nginx-server-kevin.self_link}"
  }

  health_checks = [
    google_compute_http_health_check.check-nginx-kevin.self_link,
  ]
}

resource "google_compute_http_health_check" "check-nginx-kevin" {
  name         = "check-nginx-kevin"
  request_path = "/"
}

resource "google_compute_url_map" "nginx-urlmap-kevin" {
  name        = "nginx-urlmap-kevin"
  default_service = google_compute_backend_service.nginx-service-kevin.self_link

  host_rule {
    hosts        = ["blibli-future-kevin.com"]
    path_matcher = "bliblipath"
  }

  path_matcher {
    name            = "bliblipath"
    default_service = google_compute_backend_service.nginx-service-kevin.self_link

    path_rule {
      paths   = ["/*"]
      service = google_compute_backend_service.nginx-service-kevin.self_link
    }
  }
}

resource "google_compute_target_http_proxy" "nginx-http-proxy-kevin" {
  name        = "nginx-http-proxy-kevin"
  url_map     = google_compute_url_map.nginx-urlmap-kevin.self_link
}


resource "google_compute_global_forwarding_rule" "nginx-forward-rule-kevin" {
  name       = "nginx-forward-rule-kevin"
  target     = google_compute_target_http_proxy.nginx-http-proxy-kevin.self_link
  port_range = "80"
}