terraform {

  backend "s3" {

    bucket = "terraform-state-dev-demo"

    key = "prod/terraform.tfstate"

    region = "us-east-1"

    encrypt = true
  }
}
