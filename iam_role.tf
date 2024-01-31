resource "aws_iam_role" "iamrole" {
  name               = var.role_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags = {
    Name        = "3TierApp"
    Environment = "dev"
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "attach_policy1" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.iamrole.name
  depends_on = [aws_iam_role.iamrole]
}

resource "aws_iam_role_policy_attachment" "attach_policy2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.iamrole.name
  depends_on = [aws_iam_role.iamrole]
}

resource "aws_iam_instance_profile" "ec2-profile" {
  name       = "three-tier-ec2-profile"
  role       = aws_iam_role.iamrole.name
  depends_on = [aws_iam_role.iamrole]
}
