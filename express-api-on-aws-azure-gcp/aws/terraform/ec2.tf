provider "aws" {
  region = "us-east-1" // replace with your preferred AWS region
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_iam_policy_document" "s3" {
  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]

    resources = [
      "arn:aws:s3:::*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]

    resources = [
      "arn:aws:s3:::*/*"
    ]
  }
}

data "aws_iam_policy_document" "ssm_policy" {
  statement {
    effect = "Allow"

    actions = [
      "ssm:DescribeAssociation",
      "ssm:GetDeployablePatchSnapshotForInstance",
      "ssm:GetDocument",
      "ssm:DescribeDocument",
      "ssm:GetManifest",
      "ssm:GetParameters",
      "ssm:ListAssociations",
      "ssm:ListInstanceAssociations",
      "ssm:PutInventory",
      "ssm:PutComplianceItems",
      "ssm:PutConfigurePackageResult",
      "ssm:UpdateAssociationStatus",
      "ssm:UpdateInstanceAssociationStatus",
      "ssm:UpdateInstanceInformation"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "ssm_role" {
  name = "ssm_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ssm_role_policy" {
  name = "ssm_role_policy"
  role = aws_iam_role.ssm_role.id

  policy = data.aws_iam_policy_document.ssm_policy.json
}

resource "aws_iam_role_policy" "s3_role_policy" {
  name = "s3_role_policy"
  role = aws_iam_role.ssm_role.id

  policy = data.aws_iam_policy_document.s3.json
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ssm_profile"
  role = aws_iam_role.ssm_role.name
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_spot_instance_request" "example" {
  ami           = data.aws_ami.amazon_linux_2.id
  spot_price    = "0.05" // adjust as per your budget
  instance_type = "t3.medium"
  key_name      = aws_key_pair.deployer.key_name
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name

  tags = {
    Name = "SpotInstance"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
              sudo yum install -y nodejs
              sudo yum install -y git
              sudo yum install https://dl.k6.io/rpm/repo.rpm -y
              sudo yum install --nogpgcheck k6 -y
              EOF
}

