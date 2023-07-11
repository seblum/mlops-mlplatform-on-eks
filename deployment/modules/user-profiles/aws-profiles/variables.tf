variable "profile" {
  # type = object({
  #   name = string
  # })
  type = map(any)

  description = "Profile configuration as object"
}