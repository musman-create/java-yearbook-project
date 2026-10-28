terraform {
  backend "s3" {
    bucket       = "musman-terraform-state-310792824160-us-east-1"
    key          = "java-yearbook-project/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
