output "instance_id" {
  description = "ID of EC2 instance"
  value       = "aws_instance.app_server.id"
}

#output "ec2_machinces {
#    value = aws_instance.ubuntu.*.arn 
#}