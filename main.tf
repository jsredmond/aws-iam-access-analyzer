resource "aws_accessanalyzer_analyzer" "iam_aa" {
  analyzer_name = "${var.env}_iam_aa"
}

resource "aws_iam_policy" "iam_aa_policy" {
  name        = "${var.env}_iam_aa_policy"
  description = "Policy to enable AWS IAM Access Analyzer to access CloudTrail logs on ${var.env}"

policy = <<POLICY
{
"Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "cloudtrail:GetTrail",
      "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": [
          "iam:GenerateServiceLastAccessedDetails",
          "iam:GetServiceLastAccessedDetails"
        ],
          "Resource": "*"
    },
    {
          "Effect": "Allow",
          "Action": [
            "s3:GetObject",
            "s3:ListBucket"
          ],
          "Resource": [
              "arn:aws:s3:::${var.cloudtrail}",
              "arn:aws:s3:::${var.cloudtrail}/*"
          ]
    },
    {
          "Effect": "Allow",
          "Action": [
            "kms:Decrypt"
          ],
          "Resource": [
            "arn:aws:kms:${var.ctkey}"
          ],
          "Condition": {
            "StringLike": {
              "kms:ViaService": "s3.*.amazonaws.com"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role" "iam_aa_role" {
  name = "${var.env}_iam_aa_role"
  path = "/service-role/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "access-analyzer.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    Name = "IAM Role for AWS IAM Access Analyzer to Read CloudTrail Logs"
    Environment = var.env
  }

}  

resource "aws_iam_role_policy_attachment" "iam_aa_role_policy_attachement" {
  role       = aws_iam_role.iam_aa_role.name
  policy_arn = aws_iam_policy.iam_aa_policy.arn
}

# resource "aws_organizations_organization" "aws_org" {
#   aws_service_access_principals = ["access-analyzer.amazonaws.com"]
# }

# resource "aws_accessanalyzer_analyzer" "org_iam_aa" {
#   depends_on = [aws_organizations_organization.aws_org]

#   analyzer_name = "${var.env}_org_iam_aa"
#   type          = "ORGANIZATION"
# }