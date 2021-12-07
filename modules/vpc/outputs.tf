# Put any outputs in here
# Data that needs to get sent back to the root module


output "public_sg_id" {
    value = aws_security_group.public_sg.id
}


output "private_sg_id_1" {
    value = aws_security_group.private_sg.id
}

output "db_sg_id" {
    value = aws_security_group.db_sg.id
}


output "public_subnet_id_1" {
    value = aws_subnet.some_public_subnet_1.id
}

output "public_subnet_id_2" {
    value = aws_subnet.some_public_subnet_2.id
}

output "public_subnet_id_3" {
    value = aws_subnet.some_public_subnet_3.id
}


output "private_subnet_id_1" {
    value = aws_subnet.some_private_subnet_1.id
}

output "private_subnet_id_2" {
    value = aws_subnet.some_private_subnet_2.id
}

output "private_subnet_id_3" {
    value = aws_subnet.some_private_subnet_3.id
}

output "private_subnet_id_4" {
    value = aws_subnet.some_private_subnet_4.id
}

output "private_subnet_id_5" {
    value = aws_subnet.some_private_subnet_5.id
}

output "private_subnet_id_6" {
    value = aws_subnet.some_private_subnet_6.id
}


output "vpc_id" {
    value = aws_vpc.some_custom_vpc.id
}