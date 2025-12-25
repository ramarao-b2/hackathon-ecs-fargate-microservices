resource "aws_ecr_repository" "patient" {
  name         = "patient-service"
  force_delete = true
}

resource "aws_ecr_repository" "appointment" {
  name         = "appointment-service"
  force_delete = true
}
