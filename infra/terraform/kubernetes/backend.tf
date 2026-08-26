terraform {
  backend "s3" {
    bucket = "tfstate" # Name of the S3 bucket
    endpoints = {
      s3 = "http://s3.jbernh.xyz" # Minio endpoint
    }
    key = "liquid.tfstate" # Name of the tfstate file

    access_key = "${var.s3_access_key}"
    secret_key = "${var.s3_secret_key}"

    region                      = "main" # Region validation will be skipped
    skip_credentials_validation = true   # Skip AWS related checks and validations
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    use_path_style              = true
  }
}
