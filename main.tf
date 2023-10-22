resource "aws_security_group" "alb-sg" {
  name        = "${var.name}-${var.env}-SG"
  description = "Allow ${var.name}-${var.env}-Traffic"
  vpc_id = var.vpc_id

  ingress {
    description      = "Allow inbound traffic for ${var.name}-${var.env}"
    from_port        = var.port
    to_port          = var.port
    protocol         = "tcp"
    cidr_blocks      = var.sg_subnet_cidr
  }

  ingress {
    description      = "Allow inbound traffic for ${var.name}-${var.env}"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = var.sg_subnet_cidr
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = merge({
    Name = "${var.env}-${var.name}-SG"
  },
    var.tags)
}

resource "aws_lb" "alb" {
  name               = "${var.name}-${var.env}-lb"
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = var.subnet_ids

  tags = merge({
    Name = "${var.env}-${var.name}-lb"
  },
    var.tags)
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.port
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:804838709963:certificate/90de4061-551c-4ad4-b411-f7d790aef878"


  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Default response"
      status_code  = "200"
    }
  }
}