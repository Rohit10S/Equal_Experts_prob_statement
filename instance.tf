resource "aws_key_pair" "terra-key" {
  key_name   = "terrakey"
  public_key = file(var.PUB_KEY)
}

resource "aws_instance" "terrainst" {
  ami                    = var.AMIS[var.REGION]
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.dove-pub-1.id
  key_name               = aws_key_pair.terra-key.key_name
  vpc_security_group_ids = [aws_security_group.dove.id]
  tags = {
    Name = "Terra-Instance"
  }

  user_data = <<-EOF
#!/bin/bash
sudo yum update –y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum upgrade
sudo amazon-linux-extras install java-openjdk11 -y
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
EOF
}


resource "aws_instance" "dockinst" {
  ami                    = var.AMIS[var.REGION]
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.dove-priv-1.id
  key_name               = aws_key_pair.terra-key.key_name
  vpc_security_group_ids = [aws_security_group.dove.id]
  tags = {
    Name = "Terra-Docker"
  }

  user_data = <<-EOF
#!/bin/bash
sudo yum update -y
sudo -i
yum install java -y
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.70/bin/apache-tomcat-9.0.70.tar.gz
tar -xzvf apache-tomcat-9.0.70.tar.gz
cd apache-tomcat-9.0.70/
cd bin
./startup.sh
EOF
}

resource "aws_ebs_volume" "vol_4_dove" {
  availability_zone = var.ZONE1
  size              = 3
  tags = {
    Name = "extr-vol-4-dove"
  }
}

resource "aws_volume_attachment" "atch_vol_dove" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.vol_4_dove.id
  instance_id = aws_instance.terrainst.id
}

output "PublicIP" {
  value = aws_instance.terrainst.public_ip
}