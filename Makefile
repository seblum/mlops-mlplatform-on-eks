.PHONY: terracheck
terracheck:
	terraform validate
	terraform plan
