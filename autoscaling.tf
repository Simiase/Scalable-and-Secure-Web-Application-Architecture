#create launch template for autoscaling group
resource "aws_launch_template" "launch_template" {
  name                        = "launch_template"
  image_id                    =  "${var.ami_id}"
  instance_type               = "t2.micro"
  key_name                    =  "${var.key_name}"
vpc_security_group_ids        = [aws_security_group.project_sg.id]
  user_data                   =  filebase64("${path.root}/rds.sh")

tags                          = {
     Name                     = "launch_template"
}
}
 
 #create autoscaling group
resource "aws_autoscaling_group" "auto_scaling_group" {
  desired_capacity            = 2
  max_size                    = 3
  min_size                    = 2
target_group_arns             = [aws_lb_target_group.alb_target_group.arn]
 vpc_zone_identifier          = [aws_subnet.subnetc.id]

#refrence launch template in autoscaling group
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
}