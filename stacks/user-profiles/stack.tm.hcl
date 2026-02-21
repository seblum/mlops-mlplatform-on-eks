stack {
  name        = "user-profiles"
  description = "IAM users and roles for platform developers, loaded from profiles/user-list.yaml."
  id          = "user-profiles"
  tags        = ["infra", "iam"]

  after = [
    "../eks",
  ]
}
