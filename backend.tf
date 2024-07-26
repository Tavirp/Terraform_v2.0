terraform {
  backend "s3" {
    bucket = "hhhoney-buckettt"
    key    = "Terraform_V2.0/terraform.tfstate"
    region = "eu-central-1"
  }
}
