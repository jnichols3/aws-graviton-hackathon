terraform {
  backend "local" {
    path          = "infra-terraform.tfstate"
  }
}
