resource "aws_accessanalyzer_analyzer" "iam_aa" {
  analyzer_name = "${var.env}_iam_aa"
}

# resource "aws_organizations_organization" "aws_org" {
#   aws_service_access_principals = ["access-analyzer.amazonaws.com"]
# }

# resource "aws_accessanalyzer_analyzer" "org_iam_aa" {
#   depends_on = [aws_organizations_organization.aws_org]

#   analyzer_name = "${var.env}_org_iam_aa"
#   type          = "ORGANIZATION"
# }