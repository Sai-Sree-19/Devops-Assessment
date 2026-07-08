terraform {

  backend "s3" {

    bucket = "terraform-state-dev-demo"

    key = "dev/terraform.tfstate"

    region = "us-east-1"

    encrypt = true
  }
}
