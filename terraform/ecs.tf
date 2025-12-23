# ECS Fargate configuration placeholder

resource "aws_ecs_cluster" "this" {
  name = "devops-hackathon-cluster"
}

resource "aws_security_group" "ecs_sg" {
  vpc_id = aws_vpc.this.id
  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_task_definition" "patient" {
  family                   = "patient-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = data.aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([{
    name  = "patient"
    image = "${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com/patient-service:latest"
    portMappings = [{
      containerPort = 3000
    }]
  }])
}

resource "aws_ecs_service" "patient" {
  name            = "patient-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.patient.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.private[*].id
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.patient_tg.arn
    container_name   = "patient"
    container_port   = 3000
  }

  depends_on = [
    aws_lb_listener.http
  ]
}

resource "aws_ecs_task_definition" "appointment" {
  family                   = "appointment-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = data.aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([{
    name  = "appointment"
    image = "${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com/appointment-service:latest"
    portMappings = [{
      containerPort = 3000
    }]
  }])
}

resource "aws_ecs_service" "appointment" {
  name            = "appointment-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.appointment.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.private[*].id
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.appointment_tg.arn
    container_name   = "appointment"
    container_port   = 3000
  }

  depends_on = [
    aws_lb_listener.http
  ]
}