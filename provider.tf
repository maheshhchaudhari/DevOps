provider "aws" {
  region  = "ap-south-1" # Don't change the region
}

# Add your S3 backend configuration here


terraform {
  backend "s3" {
    bucket = "3.devops.candidate.exam"
    region = "us-east-1"
    key    = "Mahesh.Chaudhari"
  }
}

