stack {
  name        = "dashboard"
  description = "Vue.js platform dashboard Helm release."
  id          = "dashboard"
  tags        = ["app", "frontend"]

  after = [
    "../networking",
  ]
}
