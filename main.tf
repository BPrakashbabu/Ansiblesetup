
#create inventory file

resource "local_file" "ansible_inventory" {
  content = templatefile("/templates/locals.tpl",
  {
    keyfile = var.ppkfile,
    demoservers = aws_instance.ansible_nodes.*.public_ip
  }
)
 filename = "./ansible/hosts.cfg"
}


# ansible nodes

resource "aws_instance" "ansible_nodes" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.ppkfile
  associate_public_ip_address = true
  
  user_data = <<-EOF
                #!/bin/bash
                sudo apt update
                sudo apt install -y python3
               EOF

  tags = {
    Name = "ansible target nodes"
  }
}


# ec2 ansible master 

resource "aws_instance" "ansible_master" {

  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.ppkfile
  associate_public_ip_address = true

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update
                sudo apt install -y ansible
               EOF
 depends_on = [aws_instance.ansible_nodes]
  tags = {
    Name = "ansible master"
  }

  provisioner "file" {
    source = "./ansible/hosts.cfg"
    destination = "/home/ubuntu/hosts.cfg"
  }
  provisioner "file" {
    source = "./${var.ppkfile}.pem"
    destination = "/home/ubuntu/${var.ppkfile}.pem"
  }
  provisioner "remote-exec"{
   inline = ["chmod 400 /home/ubuntu/${var.ppkfile}.pem"]
 }
 connection {
   type = "ssh"
   user = "ubuntu"
   private_key = file("${var.ppkfile}.pem")
   host = self.public_ip
 }

}


