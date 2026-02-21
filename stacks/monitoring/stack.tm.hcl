stack {
  name        = "monitoring"
  description = "Prometheus and Grafana Helm releases with GitHub OAuth for Grafana."
  id          = "monitoring"
  tags        = ["app", "observability"]

  after = [
    "../networking",
    "../external-secrets",
  ]
}
