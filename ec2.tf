resource "aws_key_pair" "my_key" {
  key_name = "my_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDhhq+QRmXzYsGegeekZdsPRBclNzPWOWq8ml37z4r770CvymlzGmPCt+pkwTLvJuY8rnQ3vci9l2ucnkoHuymSGdKpdv3wZ8mNhkSp5fDzj0ivyhus8x/OVUzQ9pq9EobFxMREAizyB0JBme3sP0Fh09LgdbR+TfA6QOTW9RqpYjGyMMirt5Ti8NFWmPpBwYJ1Y3A9vq9CuQ5+8zS9bP6uaVo/lPsngDk5AiKGT2DOUv/mcVGfVV2aVCSVvEP4DubO9q6B/v8suZS810e5Yr88V87TeVN9ZAsKM+CGdMfwI8DCIOeUwpV+mHuvCBlvYvC+jJGnuWbhaPS5KNYYRlJYfT2IbqAeVpL2h87GRPuHvNU07WbN7qMkQMcvOHKgHGOup+rGq5k0Kn6K/MeAJCUr8vYsM/sLyRjRGH9Oqbx9xus2qID90I2L+QbcQAhy+A7h959oy+8N357bk+R76lsL8IMvVGdsPMGC2HdDx4sOcDnfwFI1/N2wDu5UgG4HRj0="
}

resource "aws_instance" "controlplane" {
  count = 2
  ami           = "ami-06640050dc3f556bb"
  instance_type = "t3.medium"
  security_groups = [ "default" ]
  key_name = aws_key_pair.my_key.key_name
  tags = {
    Name = "controlplane-${count.index}"
  }
}

resource "aws_instance" "dataplane" {
  count = 2
  ami           = "ami-06640050dc3f556bb"
  instance_type = "t3.medium"
  security_groups = [ "default" ]
  key_name = aws_key_pair.my_key.key_name
  tags = {
    Name = "dataplane-${count.index}"
  }
}

resource "aws_instance" "worker" {
  count = 1
  ami           = "ami-06640050dc3f556bb"
  instance_type = "t3.medium"
  security_groups = [ "default" ]
  key_name = aws_key_pair.my_key.key_name
  tags = {
    Name = "worker-${count.index}"
  }
}

output "ssh-workerIp-0" {
  value = "ssh ec2-user@${aws_instance.worker.0.public_ip}"
}

output "ssh-controlplaneIp-0" {
  value = "ssh ec2-user@${aws_instance.controlplane.0.public_ip}"
}

output "ssh-controlplaneIp-1" {
  value = "ssh ec2-user@${aws_instance.controlplane.1.public_ip}"
}

output "ssh-dataplaneIp-0" {
  value = "ssh ec2-user@${aws_instance.dataplane.0.public_ip}"
}

output "ssh-dataplaneIp-1" {
  value = "ssh ec2-user@${aws_instance.dataplane.1.public_ip}"
}

output "workerIp-0" {
  value = "${aws_instance.worker.0.id} ${aws_instance.worker.0.private_ip} ${aws_instance.worker.0.public_ip}"
}

output "controlplaneIp-0" {
  value = "${aws_instance.controlplane.0.id} ${aws_instance.controlplane.0.private_ip} ${aws_instance.controlplane.0.public_ip}"
}

output "controlplaneIp-1" {
  value = "${aws_instance.controlplane.1.id} ${aws_instance.controlplane.1.private_ip} ${aws_instance.controlplane.1.public_ip}"
}

output "dataplaneIp-0" {
  value = "${aws_instance.dataplane.0.id} ${aws_instance.dataplane.0.private_ip} ${aws_instance.dataplane.0.public_ip}"
}

output "dataplaneIp-1" {
  value = "${aws_instance.dataplane.1.id} ${aws_instance.dataplane.1.private_ip} ${aws_instance.dataplane.1.public_ip}"
}
