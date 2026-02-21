stack {
  name        = "05-user-profiles"
  description = "IAM users and roles for platform developers, loaded from profiles/user-list.yaml."
  id          = "user-profiles"
  tags        = ["infra"]

  after = ["../02-eks"]
}
