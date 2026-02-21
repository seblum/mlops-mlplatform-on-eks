stack {
  name        = "11-dashboard"
  description = "Vue.js platform dashboard Helm release."
  id          = "dashboard"
  tags        = ["app"]

  after = ["../03-networking"]
}
