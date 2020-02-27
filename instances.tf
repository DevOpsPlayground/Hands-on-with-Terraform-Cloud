resource "aws_instance" "dpg-2048" {

  ami                    = data.aws_ami.amzn.id
  instance_type          = "t3a.small"
  key_name               = "jeff"
  vpc_security_group_ids = [aws_security_group.instances.id]

  associate_public_ip_address = true

  user_data = templatefile("user-data.sh.tpl", {})

  tags = {
    "Name"        = "dpg-${var.animal}-${var.env}"
    "Owner"       = "dpg-${var.animal}"
    "Project"     = "DPG"
    "Environment" = var.env
  }
}
