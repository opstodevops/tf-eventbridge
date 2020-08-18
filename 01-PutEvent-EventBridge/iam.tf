#################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

##################################################################################
# RESOURCES
##################################################################################

#This uses the default VPC.  It WILL NOT delete it on destroy.
resource "aws_default_vpc" "default" {

}

resource "aws_iam_role" "lambdarole" {
  name = "lambdarole-eventbridge"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
tags = {
      Environment = "dev"
  }
}

data "aws_iam_policy" "eventbridgefullaccess" {
  arn = "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"
}

resource "aws_iam_role_policy_attachment" "lambdarole-eventbridgefullaccess" {
  role       = aws_iam_role.lambdarole.name
  policy_arn = data.aws_iam_policy.eventbridgefullaccess.arn
}
