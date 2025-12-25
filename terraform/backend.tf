terraform {
  backend "s3" {
    bucket = "devops-hackathon-tfstate1"
    key    = "ecs/terraform.tfstate"
    region = "ap-south-1"
  }
}
