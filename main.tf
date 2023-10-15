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