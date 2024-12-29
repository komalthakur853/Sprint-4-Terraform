# Outputs
output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the main VPC"
}

output "subnet_ids" {
  value       = [
    aws_subnet.dev_public_subnet_01.id,
    aws_subnet.dev_private_frontend_subnet.id,
    aws_subnet.dev_private_backend_subnet.id,
    aws_subnet.dev_private_database_subnet.id,
    aws_subnet.dev_public_subnet_02.id
  ]
  description = "The IDs of all subnets"
}

output "nat_gateway_id" {
  value       = aws_nat_gateway.main.id
  description = "The ID of the NAT Gateway"
}

output "public_route_table_id" {
  value       = aws_route_table.public.id
  description = "The ID of the public route table"
}

output "private_route_table_id" {
  value       = aws_route_table.private.id
  description = "The ID of the private route table"
}


output "nacl_ids" {
  value = [
    aws_network_acl.public_01.id,
    aws_network_acl.private_frontend.id,
    aws_network_acl.private_backend.id,
    aws_network_acl.private_database.id,
    aws_network_acl.public_02.id
  ]
  description = "The IDs of all NACLs"
}

# sg id
output "ALB_SG_id" {
  value = aws_security_group.SG_01.id
}


# Application LB output

output "ALB_arn" {
  value = aws_lb.Ot-micro-ALB.arn
}


output "alb_dns_name" {
  value = aws_lb.Ot-micro-ALB.dns_name
  description = "The DNS name of the Application Load Balancer"
}
# target arn 
output "Target_group_arn" {
  value = aws_lb_target_group.test.arn
}

output "route53-zone-id" {
  value = aws_route53_zone.example.id
}

####################################frontend#########################################

# sg
output "frontend-sg-id" {
  value = aws_security_group.frontend-sg.id
}

# Launch template

output "launch_template" {
  value = aws_launch_template.frontend-launch_template.id
}


################################################ attendance sg ########################################
output "attendance-sg" {
  value = aws_security_group.attendance-sg.id
}

output "attendance_launch_template" {
  value = aws_launch_template.Attendance-launch_template.id
}

output "attendance-TG" {
 value = aws_lb_target_group.Dev-Attendance-TG.arn 
}


################################################Employee#######################################

output "Employee-sg" {
  value = aws_security_group.Employee-sg.id
}

output "Employee_launch_template" {
 value = aws_launch_template.Employee-launch_template.id 
}

output "Employee-TG" {
 value =  aws_lb_target_group.Dev-Employee-TG.arn
}

##################################################salary###################################

output "salary-sg" {
  value = aws_security_group.salary-sg.id
}

output "salary_launch_template" {
 value = aws_launch_template.salary-launch_template.id 
}

output "salary-TG" {
  value = aws_lb_target_group.Dev-salary-TG.arn
}
