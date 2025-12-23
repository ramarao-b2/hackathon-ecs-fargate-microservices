terraform {
  backend "s3" {
    bucket = "devops-hackathon-tfstate"
    key    = "ecs/terraform.tfstate"
    region = "ap-south-1"
  }
}