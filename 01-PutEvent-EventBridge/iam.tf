##################################################################################
# RESOURCES
##################################################################################

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

resource "aws_iam_role_policy" "lambdarole_policy" {
  name = "lambdarole-eventbridge-policy"
  role = aws_iam_role.lambdarole.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*"
      }
    ]
  }
  EOF
}

data "aws_iam_policy" "eventbridgefullaccess" {
  arn = "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"
}

resource "aws_iam_role_policy_attachment" "lambdarole-eventbridgefullaccess" {
  role       = aws_iam_role.lambdarole.name
  policy_arn = data.aws_iam_policy.eventbridgefullaccess.arn
}
