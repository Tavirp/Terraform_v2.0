resource "aws_instance" "third_instance" {
  ami                         = "ami-01e444924a2233b07"
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  security_groups             = [aws_security_group.sg1.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "EhCeh2_Instanz"
  }
}

resource "aws_dynamodb_table" "table_3152" {
  name           = "FirstDynamoDihBiehTable"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  attribute {
    name = "id"
    type = "N"
  }
}