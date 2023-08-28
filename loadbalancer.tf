# create application load balancer
resource "aws_lb" "application_load_balancer" {
  name                        = "application-load-balancer"
  internal                    = false
  load_balancer_type          = "application"
  security_groups             = [aws_security_group.project_sg.id]
   subnets                    =  [aws_subnet.subnetc.id,aws_subnet.subnetd.id,]

  tags                        = {
    Name                      = "application_load_balancer"
  }
}

# create target group
resource "aws_lb_target_group" "alb_target_group" {
  name                        = "alb-target-group"
  port                        = 80
  protocol                    = "HTTP"
  vpc_id                      = aws_vpc.rds_vpc.id

}



# create a listener on port 80 with redirect action
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn           = aws_lb.application_load_balancer.arn
  port                        = 80
  protocol                    = "HTTP"

default_action {
    type                      = "forward"
    target_group_arn          = aws_lb_target_group.alb_target_group.arn
    
  }

  }
#create a listener certificate 
resource "aws_lb_listener_certificate" "listener_cert" {
  listener_arn    = aws_lb_listener.alb_https_listener.arn
  certificate_arn = aws_acm_certificate.acm_cert.arn
}


# create a listener on port 443 with forward action
resource "aws_lb_listener" "alb_https_listener" {
  load_balancer_arn           = aws_lb.application_load_balancer.arn
  port                        = 443
  protocol                    = "HTTPS"
  certificate_arn             = aws_acm_certificate.acm_cert.arn
  default_action {
    type                      = "forward"
    target_group_arn          = aws_lb_target_group.alb_target_group.arn
  }
}

