resource "aws_instance" "bastion" {
   instance_type 		= "t2.micro"
   ami 		 		= "${var.ami_id}"
   subnet_id 			= "${aws_subnet.workload_public[0].id}"
   key_name 			= "${var.bastion_host_key}"
   associate_public_ip_address 	= true
   disable_api_termination   	= true
   iam_instance_profile		= "SSMInstanceProfile-gurmukh"
   monitoring			= true
   vpc_security_group_ids 	= ["${aws_security_group.dbt_cloud.id}","${aws_security_group.public_local_vpc.id}","${aws_security_group.public_workspace_vpc.id}"]

root_block_device {
    volume_size           = 10
    volume_type           = "gp3"
    delete_on_termination = true
    tags = {
      Name = "${var.org}-${var.project}-bastion-root-volume"
    }
  }

tags = {
    Name = "${var.org}-${var.project}-bastion"
  }
}

resource "aws_eip" "bastion_host_eip" {
  instance = aws_instance.bastion.id
  vpc      = true

  tags = {
      Name = "${var.org}-${var.project}-bastion-eip"
    }
}

