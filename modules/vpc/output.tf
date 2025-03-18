output "vpc_id" {
  value = aws_vpc.main.id
}
output "private_subnet_ids" {
  value = [for subnet in aws_subnet.this : subnet.id if !subnet.map_public_ip_on_launch] // Adjust this logic if necessary
}

output "subnet_details" {
  value = { for k, v in var.subnet_details : k => { id = aws_subnet.this[k].id, cidr = v.cidr, az = v.az } if v.public == false }
}