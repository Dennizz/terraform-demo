/* set the customer id (license key) */
resource "aviatrix_customer_id" "customer_id" {
    provider = "aviatrix.demo"
    customer_id = "${local.aviatrix_customer_id}"
}


/* aws provider */
provider "aws" {
    alias = "demo"
    region     = "us-west-2"
    access_key = "${local.aws_access_key}"
    secret_key = "${local.aws_secret_key}"
}
data "aws_caller_identity" "current" {
    provider = "aws.demo"
}

/* create aviatrix account to link to AWS */
resource "aviatrix_account" "controller_demo" {
    provider = "aviatrix.demo"
    account_name = "${local.aviatrix_account_name}"
    account_password = "${local.aviatrix_password}"
    account_email = "${local.aviatrix_admin_email}"
    cloud_type = "1"
    aws_account_number = "${data.aws_caller_identity.current.account_id}"
    aws_iam = "true"
    aws_role_app = "${data.aws_cloudformation_stack.controller_quickstart.outputs["AviatrixRoleAppARN"]}"
    aws_role_ec2 = "${data.aws_cloudformation_stack.controller_quickstart.outputs["AviatrixRoleEC2ARN"]}"
    depends_on = [ "data.aws_caller_identity.current",
        "data.aws_cloudformation_stack.controller_quickstart" ]
}
