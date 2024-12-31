# +++++++++++++++++++++++++++++++++++++++++++++++++++
# Network Skeleton - Pratik Gondkar #################
# VPC

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.vpc_instance_tenancy

  tags = {
    Name = var.vpc_name
  }
}

# Subnets

resource "aws_subnet" "dev_public_subnet_01" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.dev_public_subnet_01_cidr
  availability_zone       = var.availability_zone_1

  tags = {
    Name = var.dev_public_subnet_01_Name
  }
}

resource "aws_subnet" "dev_private_frontend_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.dev_private_frontend_subnet_cidr
  availability_zone       = var.availability_zone_1

  tags = {
    Name = var.dev_private_frontend_subnet_Name
  }
}

resource "aws_subnet" "dev_private_backend_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.dev_private_backend_subnet_cidr
  availability_zone       = var.availability_zone_1

  tags = {
    Name = var.dev_private_backend_subnet_Name
  }
}

resource "aws_subnet" "dev_private_database_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.dev_private_database_subnet_cidr
  availability_zone       = var.availability_zone_1

  tags = {
    Name = var.dev_private_database_subnet_Name
  }
}

resource "aws_subnet" "dev_public_subnet_02" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.dev_public_subnet_02_cidr
  availability_zone       = var.availability_zone_2

  tags = {
    Name = var.dev_public_subnet_02_Name
  }
}

# Internet Gateway

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.aws_internet_gateway_Name
  }
}

# Elastic IP for NAT Gateway

resource "aws_eip" "nat" {
   domain = var.aws_eip_domain

  tags = {
    Name = var.aws_eip_name
  }
}

# NAT Gateway

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.dev_public_subnet_01.id

  tags = {
    Name = var.aws_nat_gateway_name
  }
}

# Public Route Table

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.aws_public_route_table_cidr_block
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = var.aws_public_route_table_name
  }
}

# Private Route Table

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = var.aws_private_route_table_cidr_block
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = var.aws_private_route_table_name
  }
}


# Route Table Associations

resource "aws_route_table_association" "public_subnet_01" {
  subnet_id      = aws_subnet.dev_public_subnet_01.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_subnet_02" {
  subnet_id      = aws_subnet.dev_public_subnet_02.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_frontend_subnet" {
  subnet_id      = aws_subnet.dev_private_frontend_subnet.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_backend_subnet" {
  subnet_id      = aws_subnet.dev_private_backend_subnet.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_database_subnet" {
  subnet_id      = aws_subnet.dev_private_database_subnet.id
  route_table_id = aws_route_table.private.id
}




#NCAL

# Public NACL for dev-public-subnet-01
resource "aws_network_acl" "public_01" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.aws_public_01_network_acl
  }
}

resource "aws_network_acl_rule" "public_01_ingress_ssh" {
  network_acl_id = aws_network_acl.public_01.id
  rule_number    = 100
  protocol       = var.protocol_tcp
  rule_action    = var.rule_action
  cidr_block     = var.cidr_block_public
  from_port      = 22
  to_port        = 22
  egress         = var.egress_default
}

resource "aws_network_acl_rule" "public_01_ingress_http" {
  network_acl_id = aws_network_acl.public_01.id
  rule_number    = 110
  protocol       = var.protocol_tcp
  rule_action    = var.rule_action
  cidr_block     = var.cidr_block_public
  from_port      = 80
  to_port        = 80
  egress         = var.egress_default
}

resource "aws_network_acl_rule" "public_01_egress" {
  network_acl_id = aws_network_acl.public_01.id
  rule_number    = 200
  protocol       = var.protocol_all
  rule_action    = var.rule_action
  cidr_block     = var.cidr_block_public
  egress         = true
}

# Private NACL for dev-private-frontend-subnet
resource "aws_network_acl" "private_frontend" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Private-Frontend-NACL"
  }
}

resource "aws_network_acl_rule" "frontend_ingress_ssh" {
  network_acl_id = aws_network_acl.private_frontend.id
  rule_number    = 100
  protocol       = var.protocol_tcp
  rule_action    = var.rule_action
  cidr_block     = var.cidr_block_private
  from_port      = 22
  to_port        = 22
  egress         = var.egress_default
}

resource "aws_network_acl_rule" "frontend_ingress_app" {
  network_acl_id = aws_network_acl.private_frontend.id
  rule_number    = 110
  protocol       = var.protocol_tcp
  rule_action    = var.rule_action
  cidr_block     = var.cidr_block_private
  from_port      = 3000
  to_port        = 3000
  egress         = var.egress_default
}

resource "aws_network_acl_rule" "frontend_egress" {
  network_acl_id = aws_network_acl.private_frontend.id
  rule_number    = 200
  protocol       = var.protocol_all
  rule_action    = var.rule_action
  cidr_block     = var.cidr_block_public
  egress         = true
}

# Private NACL for dev-private-backend-subnet
resource "aws_network_acl" "private_backend" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Private-Backend-NACL"
  }
}

resource "aws_network_acl_rule" "backend_ingress_ssh" {
  network_acl_id = aws_network_acl.private_backend.id
  rule_number    = 100
  protocol       = var.protocol_tcp
  rule_action    = var.rule_action
  cidr_block     = var.cidr_block_private
  from_port      = 22
  to_port        = 22
  egress         = false
}

resource "aws_network_acl_rule" "backend_ingress_app" {
  network_acl_id = aws_network_acl.private_backend.id
  rule_number    = 110
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "10.0.0.112/28"
  from_port      = 8080
  to_port        = 8080
  egress         = false
}

resource "aws_network_acl_rule" "backend_egress" {
  network_acl_id = aws_network_acl.private_backend.id
  rule_number    = 200
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  egress         = true
}

# Private NACL for dev-private-database-subnet
resource "aws_network_acl" "private_database" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Private-Database-NACL"
  }
}

resource "aws_network_acl_rule" "database_ingress_ssh" {
  network_acl_id = aws_network_acl.private_database.id
  rule_number    = 100
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/27"
  from_port      = 22
  to_port        = 22
  egress         = false
}

resource "aws_network_acl_rule" "database_ingress_redis" {
  network_acl_id = aws_network_acl.private_database.id
  rule_number    = 110
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "10.0.0.112/28"
  from_port      = 6379
  to_port        = 6379
  egress         = false
}

resource "aws_network_acl_rule" "database_ingress_postgres" {
  network_acl_id = aws_network_acl.private_database.id
  rule_number    = 120
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "10.0.0.112/28"
  from_port      = 5432
  to_port        = 5432
  egress         = false
}

resource "aws_network_acl_rule" "database_ingress_kafka" {
  network_acl_id = aws_network_acl.private_database.id
  rule_number    = 130
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "10.0.0.112/28"
  from_port      = 9092
  to_port        = 9092
  egress         = false
}

resource "aws_network_acl_rule" "database_egress" {
  network_acl_id = aws_network_acl.private_database.id
  rule_number    = 200
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  egress         = true
}

# Public NACL for dev-public-subnet-02
resource "aws_network_acl" "public_02" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Public-NACL-02"
  }
}

resource "aws_network_acl_rule" "public_02_ingress_ssh" {
  network_acl_id = aws_network_acl.public_02.id
  rule_number    = 100
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
  egress         = false
}

resource "aws_network_acl_rule" "public_02_egress" {
  network_acl_id = aws_network_acl.public_02.id
  rule_number    = 200
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  egress         = true
}


# target group

resource "aws_lb_target_group" "test" {
  name     = var.OtMicro-TG
  port     = 3000
  protocol = var.protocol_type
  vpc_id   = aws_vpc.main.id
   health_check {
    interval            = var.interval
    path                = var.path
    protocol            = var.protocol_type
    timeout             = var.timeout
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
  }
  
}

# Laod balancer sg

resource "aws_security_group" "SG_01" {
  
  vpc_id      = aws_vpc.main.id
  ingress  {
    from_port   = var.HTTP_port
    to_port     = var.HTTP_port
    protocol    = var.protocol_tcp
    cidr_blocks = [var.sg_cidr_range]
    description      = "Allow traffic from interner"
  }
  egress  {
    from_port   = var.allow_port
    to_port     = var.allow_port
    protocol    = var.protocol_01
    cidr_blocks = [var.sg_cidr_range]
  }

  tags = {
    Name = var.ALB_SG
  }
}


# Load balancer 

resource "aws_lb" "Ot-micro-ALB" {
  name               = var.Load_balancer_name
  internal           = var.internal_value
  load_balancer_type = var.ALB_type
  security_groups    = [aws_security_group.SG_01.id]
  subnets            = [aws_subnet.dev_public_subnet_01.id , aws_subnet.dev_public_subnet_02.id]
}


# load balancer listener

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.Ot-micro-ALB.id
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}


# Route 53 hosted zone

resource "aws_route53_zone" "example" {
  name = var.domain-name         
}

resource "aws_route53_record" "cname_record" {
  zone_id = aws_route53_zone.example.zone_id
  name    = var.cname
  type    = "CNAME"
  ttl     = 30
  records = [aws_lb.Ot-micro-ALB.dns_name] 
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++
# frontend setup - Pritam Kondapratiwar #############
# sg
resource "aws_security_group" "frontend-sg" {
  vpc_id      = aws_vpc.main.id
  ingress  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress  {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    security_groups = [aws_security_group.SG_01.id]
  }
  egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Dev-frontend-sg"
  }
}


# launch template

resource "aws_launch_template" "frontend-launch_template" {
  name_prefix   = "frontend-Launch-template"
  
  # Basic instance configuration
  image_id      = "ami-053b12d3152c0cc71" # Replace with your AMI ID
  instance_type = "t3.medium"             # Replace with desired instance type
  key_name      = "key-pair"
  # Network settings
  network_interfaces {
    associate_public_ip_address = false   # Public IP disable
    subnet_id                   = aws_subnet.dev_private_frontend_subnet.id # Replace with private subnet ID
    security_groups             = [aws_security_group.frontend-sg.id] # Replace with your security group ID
  }

}

resource "aws_autoscaling_group" "example" {
  launch_template {
    id      = aws_launch_template.frontend-launch_template.id
    version = "$Latest"
  }
  name               = "ASG"
  min_size           = 1
  max_size           = 1
  desired_capacity   = 1

  vpc_zone_identifier = [aws_subnet.dev_private_frontend_subnet.id] # Replace with your private subnet ID
  # Attach the target group
  target_group_arns = [aws_lb_target_group.test.arn]

   tag {
    key                 = "Name"
    value               = "Dev-frontend-Instance"
    propagate_at_launch = true
  }

}


#  ASG policy
resource "aws_autoscaling_policy" "frontend_autoscaling_policy" {
  name                   = "frontend-autoscaling-policy"
  policy_type            = "TargetTrackingScaling"
  adjustment_type        = "ChangeInCapacity"
  estimated_instance_warmup = 300
  autoscaling_group_name = aws_autoscaling_group.example.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}


##############################################################################
# Setup Attendance App infra in dev env via terraform static code - Priyanshu #
##############################################################################

resource "aws_security_group" "attendance-sg" {
  vpc_id      = aws_vpc.main.id
  ingress  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress  {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [aws_security_group.frontend-sg.id]
    description      = "Allow traffic from frontend on port 3000"
  }
  egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Dev-attendance-sg"
  }
}



# Launch template for attendance
resource "aws_launch_template" "Attendance-launch_template" {
  name_prefix   = "Attendance-Launch-template"
  
  # Basic instance configuration
  image_id      = "ami-053b12d3152c0cc71" # Replace with your AMI ID
  instance_type = "t2.micro"             # Replace with desired instance type
  key_name      = "key-pair"
  # Network settings
  network_interfaces {
    associate_public_ip_address = false   # Public IP disable
    subnet_id                   = aws_subnet.dev_private_backend_subnet.id 
    security_groups             = [aws_security_group.attendance-sg.id] # Replace with your security group ID
  }

}

# Creating the Target Group
resource "aws_lb_target_group" "Dev-Attendance-TG" {
  name     = "Dev-attendance-tg"
  port     = 8080 # Listening on port 80 (for load balancer)
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    interval            = 30
    path                = "/api/v1/attendance/health"
    protocol            = "HTTP"
    timeout             = 2
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "attendance_asg" {
  name                = "DEV-Attendance-ASG"
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  vpc_zone_identifier = [
    aws_subnet.dev_private_backend_subnet.id # Reference to a single subnet ID
  ]
  launch_template {
    id      = aws_launch_template.Attendance-launch_template.id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300
  force_delete              = true
  wait_for_capacity_timeout = "0"

  target_group_arns = [aws_lb_target_group.Dev-Attendance-TG.arn]  # Register with Target Group

  tag {
    key                 = "Name"
    value               = "Dev-Attendance-Instance"
    propagate_at_launch = true
  }
}

# ALB Listener Rule for Attendance Application
resource "aws_lb_listener_rule" "attendance_rule" {
  listener_arn = aws_lb_listener.http_listener.arn  # Reference the ALB HTTP listener
  priority     = 4

  # Correctly specify conditions for the listener rule
  condition {
    path_pattern {
      values = ["/api/v1/attendance/*", "/apidocs/*", "/flasgger_static/*", "/apispec_1.json"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Dev-Attendance-TG.arn  # Forward to the attendance target group
  }
}


#  ASG policy
resource "aws_autoscaling_policy" "attendance_autoscaling_policy" {
  name                   = "attendance-autoscaling-policy"
  policy_type            = "TargetTrackingScaling"
  adjustment_type        = "ChangeInCapacity"
  estimated_instance_warmup = 300
  autoscaling_group_name = aws_autoscaling_group.attendance_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}


###########################################################################################
# Employee - Radha Gondchor                                                       ##############
################################################################################################

resource "aws_security_group" "Employee-sg" {
  vpc_id      = aws_vpc.main.id
  ingress  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress  {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [aws_security_group.frontend-sg.id]
    description      = "Allow traffic from frontend on port 3000"
  }
  egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Dev-Employee-sg"
  }
}



# Launch template for Employee
resource "aws_launch_template" "Employee-launch_template" {
  name_prefix   = "Employee-Launch-template"
  
  # Basic instance configuration
  image_id      = "ami-053b12d3152c0cc71" # Replace with your AMI ID
  instance_type = "t2.micro"             # Replace with desired instance type
  key_name      = "key-pair"
  # Network settings
  network_interfaces {
    associate_public_ip_address = false   # Public IP disable
    subnet_id                   = aws_subnet.dev_private_backend_subnet.id 
    security_groups             = [aws_security_group.Employee-sg.id] # Replace with your security group ID
  }

}

# Creating the Target Group
resource "aws_lb_target_group" "Dev-Employee-TG" {
  name     = "Dev-Employee-tg"
  port     = 8080 # Listening on port 80 (for load balancer)
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    interval            = 30
    path                = "/api/v1/employee/health"
    protocol            = "HTTP"
    timeout             = 2
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "Employee_asg" {
  name                = "DEV-Employee-ASG"
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  vpc_zone_identifier = [
    aws_subnet.dev_private_backend_subnet.id # Reference to a single subnet ID
  ]
  launch_template {
    id      = aws_launch_template.Employee-launch_template.id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300
  force_delete              = true
  wait_for_capacity_timeout = "0"

  target_group_arns = [aws_lb_target_group.Dev-Employee-TG.arn]  # Register with Target Group

  tag {
    key                 = "Name"
    value               = "Dev-Employee-Instance"
    propagate_at_launch = true
  }
}

# ALB Listener Rule for Employee Application
resource "aws_lb_listener_rule" "Employee_rule" {
  listener_arn = aws_lb_listener.http_listener.arn  # Reference the ALB HTTP listener
  priority     = 2

  # Correctly specify conditions for the listener rule
  condition {
    path_pattern {
      values =  ["/swagger/*", "/api/v1/employee/*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Dev-Employee-TG.arn # Forward to the attendance target group
  }
}


#  ASG policy
resource "aws_autoscaling_policy" "Employee_autoscaling_policy" {
  name                   = "Employee-autoscaling-policy"
  policy_type            = "TargetTrackingScaling"
  adjustment_type        = "ChangeInCapacity"
  estimated_instance_warmup = 300
  autoscaling_group_name = aws_autoscaling_group.Employee_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}



###########################################################################################
# salary- Komal
################################################################################################

resource "aws_security_group" "salary-sg" {
  vpc_id      = aws_vpc.main.id
  ingress  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress  {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [aws_security_group.frontend-sg.id]
    description      = "Allow traffic from frontend on port 3000"
  }
  egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Dev-salary-sg"
  }
}



# Launch template for salary
resource "aws_launch_template" "salary-launch_template" {
  name_prefix   = "salary-Launch-template"
  
  # Basic instance configuration
  image_id      = "ami-053b12d3152c0cc71" # Replace with your AMI ID
  instance_type = "t2.micro"             # Replace with desired instance type
  key_name      = "key-pair"
  # Network settings
  network_interfaces {
    associate_public_ip_address = false   # Public IP disable
    subnet_id                   = aws_subnet.dev_private_backend_subnet.id 
    security_groups             = [aws_security_group.salary-sg.id] # Replace with your security group ID
  }

}

# Creating the Target Group
resource "aws_lb_target_group" "Dev-salary-TG" {
  name     = "Dev-salary-tg"
  port     = 8080 # Listening on port 80 (for load balancer)
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    interval            = 30
    path                = "/actuator/prometheus"
    protocol            = "HTTP"
    timeout             = 2
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "salary_asg" {
  name                = "DEV-salary-ASG"
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  vpc_zone_identifier = [
    aws_subnet.dev_private_backend_subnet.id # Reference to a single subnet ID
  ]
  launch_template {
    id      = aws_launch_template.salary-launch_template.id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300
  force_delete              = true
  wait_for_capacity_timeout = "0"

  target_group_arns = [aws_lb_target_group.Dev-salary-TG.arn]  # Register with Target Group

  tag {
    key                 = "Name"
    value               = "Dev-salary-Instance"
    propagate_at_launch = true
  }
}

# ALB Listener Rule for salary Application
resource "aws_lb_listener_rule" "salary_rule" {
  listener_arn = aws_lb_listener.http_listener.arn  # Reference the ALB HTTP listener
  priority     = 3

  # Correctly specify conditions for the listener rule
  condition {
    path_pattern {
      values =  ["/salary-documentation", "/swagger-ui/*", "/api/v1/salary/*", "/actuator/*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Dev-salary-TG.arn # Forward to the attendance target group
  }
}


#  ASG policy
resource "aws_autoscaling_policy" "salary_autoscaling_policy" {
  name                   = "salary-autoscaling-policy"
  policy_type            = "TargetTrackingScaling"
  adjustment_type        = "ChangeInCapacity"
  estimated_instance_warmup = 300
  autoscaling_group_name = aws_autoscaling_group.salary_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}



########################################  Redis - Chander kant Soni #####################################

resource "aws_security_group" "redis-sg" {
  vpc_id      = aws_vpc.main.id
  ingress  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress  {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    security_groups = [aws_security_group.attendance-sg.id]
    description      = "Allow traffic from attendance on port 8080"
  }
  egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress  {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    security_groups = [aws_security_group.Employee-sg.id]
    description      = "Allow traffic from employee on port 8080"
  }
  egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress  {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    security_groups = [aws_security_group.salary-sg.id]
    description      = "Allow traffic from salary on port 8080"
  }
  egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Dev-redis-sg"
  }
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++
# EC2- Chander Kant Soni            #################


resource "aws_instance" "redis_ec2" {
  ami           = "ami-053b12d3152c0cc71" 
  instance_type = "t2.micro"

  subnet_id              = aws_subnet.dev_private_database_subnet.id
  security_groups        = [aws_security_group.redis-sg.id]
  associate_public_ip_address = false 

  tags = {
    Name = "Dev-redis-server"
  }
}

###################################### scylla-db- Pritam ##############################

resource "aws_security_group" "scylla-db-sg" {
  vpc_id      = aws_vpc.main.id
  ingress  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress  {
    from_port   = 9042
    to_port     = 9042
    protocol    = "tcp"
    security_groups = [aws_security_group.Employee-sg.id]
    description      = "Allow traffic from employee on port 8080"
  }
  egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress  {
    from_port   = 9042
    to_port     = 9042
    protocol    = "tcp"
    security_groups = [aws_security_group.salary-sg.id]
    description      = "Allow traffic from salary on port 8080"
  }
  egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Dev-scylla-db-sg"
  }
}

resource "aws_instance" "scylla_ec2" {
  ami           = "ami-053b12d3152c0cc71" 
  instance_type = "t3.medium"

  subnet_id              = aws_subnet.dev_private_database_subnet.id
  security_groups        = [aws_security_group.scylla-db-sg.id]
  associate_public_ip_address = false 

  tags = {
    Name = "Dev-scylla-server"
  }
}


############################################postgresSql - Radha #################################

resource "aws_security_group" "postgresSql-sg" {
  vpc_id      = aws_vpc.main.id
  ingress  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress  {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.attendance-sg.id]
    description      = "Allow traffic from attendance on port 8080"
  }
  egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Dev-postgresSql-sg"
  }
}

resource "aws_instance" "postgresSql_ec2" {
  ami           = "ami-053b12d3152c0cc71" 
  instance_type = "t3.medium"

  subnet_id              = aws_subnet.dev_private_database_subnet.id
  security_groups        = [aws_security_group.postgresSql-sg.id]
  associate_public_ip_address = false 

  tags = {
    Name = "Dev-postgresSql-server"
  }
}

