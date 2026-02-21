stack {
  name        = "09-monitoring"
  description = "Prometheus and Grafana Helm releases with GitHub OAuth for Grafana."
  id          = "monitoring"
  tags        = ["app"]

  after = ["../03-networking"]
}
