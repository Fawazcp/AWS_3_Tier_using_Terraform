resource "aws_ami_from_instance" "apptier-ami" {
  name               = "apptier-image"
  source_instance_id = aws_instance.app-tier.id
  depends_on         = [aws_instance.app-tier]
}
