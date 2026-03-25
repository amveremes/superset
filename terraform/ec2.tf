
resource "aws_key_pair" "ssh_key_pub" {
  key_name   = "superset_ssh_key"
  public_key = var.ssh_key_pub
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "superset_sg" {
  name        = "superset_security_group"
  description = "Allow HTTP, HTTPS, SSH and port 9090"
  vpc_id      = data.aws_vpc.public.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "ssm_role" {
  name = "SSMRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "SSMInstanceProfile"
  role = aws_iam_role.ssm_role.name
}

resource "aws_instance" "superset" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  subnet_id                   = data.aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.superset_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh_key_pub.key_name

  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "Apache Superset"
  }
}

# IP Public v4 fix
resource "aws_eip" "superset_eip" {
  domain = "vpc"
}

resource "aws_eip_association" "superset_eip_association" {
  instance_id   = aws_instance.superset.id
  allocation_id = aws_eip.superset_eip.id
}