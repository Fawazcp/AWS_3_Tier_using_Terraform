resource "aws_security_group" "internet_facing_lb_sg" {
  name        = "internet_facing-security-group"
  description = "External load balancer sg"
  vpc_id      = aws_vpc.aws-vpc.id
  tags = {
    Name        = "Internet_Facing_LB_SG"
    Environment = "dev"
  }
}

resource "aws_security_group_rule" "internet_facing_lb_ingress" {
  security_group_id = aws_security_group.internet_facing_lb_sg.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "internet_facing_lb_egress" {
  security_group_id = aws_security_group.internet_facing_lb_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"] # Allow all traffic to all destinations
}

# Security Group For Web Tier
resource "aws_security_group" "WebTierSG" {
  name        = "webtier-security-group"
  description = "Security group for web tier"
  vpc_id      = aws_vpc.aws-vpc.id
  tags = {
    Name        = "WebTierSG"
    Environment = "dev"
  }
}

resource "aws_security_group_rule" "WebTierSG_ingress" {
  security_group_id = aws_security_group.WebTierSG.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "traffic_from_internet_facing-lb-sg" {
  security_group_id        = aws_security_group.WebTierSG.id
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.internet_facing_lb_sg.id
}

resource "aws_security_group_rule" "WebTierSG_OutBound_TCP" {
  security_group_id = aws_security_group.WebTierSG.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Internal Load Balancer SG
resource "aws_security_group" "internal-lb-sg" {
  name        = "internal-lb-sg"
  description = "Security group for internal lb"
  vpc_id      = aws_vpc.aws-vpc.id
  tags = {
    Name        = "Internal-LB-SG"
    Environment = "dev"
  }
}

resource "aws_security_group_rule" "traffic_to_internal_facing-lb-sg" {
  security_group_id        = aws_security_group.internal-lb-sg.id
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.WebTierSG.id
}

resource "aws_security_group_rule" "internal-lb-sg_egress" {
  security_group_id = aws_security_group.internal-lb-sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"] # Allow all traffic to all destinations
}

# Security Group For Private Instance
resource "aws_security_group" "PrivateinstanceSG" {
  name        = "PrivateinstanceSG"
  description = "Security group for private app tier sg"
  vpc_id      = aws_vpc.aws-vpc.id
  tags = {
    Name        = "PrivateinstanceSG"
    Environment = "dev"
  }
}

resource "aws_security_group_rule" "PrivateinstanceSG_ingress" {
  security_group_id = aws_security_group.PrivateinstanceSG.id
  type              = "ingress"
  from_port         = 4000
  to_port           = 4000
  protocol          = "tcp"
  cidr_blocks       = ["92.97.97.250/32"]
}

resource "aws_security_group_rule" "PrivateinstanceSG_rule" {
  security_group_id        = aws_security_group.PrivateinstanceSG.id
  type                     = "ingress"
  from_port                = 4000
  to_port                  = 4000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.internal-lb-sg.id
}

resource "aws_security_group_rule" "PrivateinstanceSG_OutBound_TCP" {
  security_group_id = aws_security_group.PrivateinstanceSG.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}


# Security Group For RDS Database
resource "aws_security_group" "database-sg" {
  name        = "database-sg"
  description = "Security group for databases"
  vpc_id      = aws_vpc.aws-vpc.id
  tags = {
    Name        = "Database-SG"
    Environment = "dev"
  }
}

resource "aws_security_group_rule" "database-sg_rule" {
  security_group_id        = aws_security_group.database-sg.id
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.PrivateinstanceSG.id
}

resource "aws_security_group_rule" "database-sg_egress" {
  security_group_id = aws_security_group.database-sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"] # Allow all traffic to all destinations
}