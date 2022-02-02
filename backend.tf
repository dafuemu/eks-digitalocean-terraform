# Remote state
terraform {
  backend "s3" {
    endpoint                    = "fra1.digitaloceanspaces.com/" # specify the correct DO region
    region                      = "eu-west-1" # not used since it's a DigitalOcean spaces bucket
    key                         = "aws/terraform.tfstate"
    bucket                      = "dfm-terraform-state" # The name of your Spaces

    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}