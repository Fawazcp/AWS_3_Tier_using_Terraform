resource "aws_ami_from_instance" "apptier-ami" {
  name               = "apptier-image"
  source_instance_id = aws_instance.app-tier.id
  depends_on         = [aws_instance.app-tier]
}

resource "aws_ami_from_instance" "webtier-ami" {
  name               = "webtier-image"
  source_instance_id = aws_instance.web-tier.id
  depends_on         = [aws_instance.web-tier]
}
