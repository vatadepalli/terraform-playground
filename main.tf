provider "aws" { # this will be the default provider
  region = "ap-south-1"
}

provider "aws" {
  region = "us-east-1"
  alias  = "nvirginia"
}

resource "aws_security_group" "my_security_group" {
  vpc_id = aws_vpc.my_vpc.id
  name   = "Example security group"
}

resource "aws_security_group_rule" "tls_in" {
  protocol          = "tcp"
  security_group_id = aws_security_group.my_security_group.id
  from_port         = 443
  to_port           = 443
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "http_in" {
  protocol          = "tcp"
  security_group_id = aws_security_group.my_security_group.id
  from_port         = 80
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}



resource "aws_s3_bucket" "first_bucket" {
  bucket = "vatadepalli-first-bucket"
}


data "aws_s3_bucket" "bucket" {
  bucket = "cloudzsh"
}

data "aws_iam_policy_document" "policy_s3_1" {

  statement {
    actions   = ["s3:ListBucket"]
    resources = [data.aws_s3_bucket.bucket.arn]
    effect    = "Allow"
  }

}

resource "aws_iam_policy" "my_bucket_policy" {
  name = "my-bucket-policy"

  policy = file("./policy.iam")
}


output "bucket_cloudzsh" {
  value = data.aws_s3_bucket.bucket
}


output "bucket_cloudzsh_arn" {
  value = data.aws_s3_bucket.bucket.arn
}

output "bucket_cloudzsh_name_arn" {
  value = "bucket name: ${data.aws_s3_bucket.bucket.id}, bucket arn: ${data.aws_s3_bucket.bucket.arn}"
}

resource "aws_s3_bucket" "bucket_from_locals" {
  bucket = local.bucket_name
}

output "rendered_template" {
  value = local.rendered
}

output "rendered_template_arr_iter" {
  value = templatefile("./backends.tpl", { port = 8080, ip_addrs = ["10.0.0.1", "10.0.0.2"] })
}


# variables
variable "bucket_name" {
  description = "the name of the bucket you wish to create"
  default     = "cooperfield"
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}


variable "instance_map" {}
variable "environment_type" {}

output "selected_instance" {
  value = var.instance_map[var.environment_type]
}


# terraform init
# terraform plan
# terraform plan -out myPlan
# terraform apply
# terraform apply -auto-approve
# terraform myPlan
# terraform destroy
# terraform state list
# terraform fmt

# terraform import aws_s3_bucket.bucket cloudzsh
# terraform import <resource_type>.<resource_identifier> <value>
# terraform state list
# terraform state rm 'aws_s3_bucket.bucket'
# terraform state rm <resource_name>.<resource_idenitifier>
# terraform state mv -state-out=../state_example_02a/terraform.tfstate aws_vpc.main aws_vpc.my_vpc
# terraform apply -var bucket_name=santa69

# export TF_VAR_bucket_name=santa88

# ----- SIMPLE TYPES -----
# string
# number
# bool

variable "a" {
  type    = string
  default = "foo"
}

variable "b" {
  type    = bool
  default = true

  # true
  # false
  # “true”
  # "false"
  # "1" (evaluated to true)
  # "0" (evaluated to false)
}

variable "c" {
  type    = number
  default = 123
}

output "a" {
  value = var.a
}

output "b" {
  value = var.b
}

output "c" {
  value = var.c
}

# ----- COMPLEX TYPES -----
# list(<TYPE>)
variable "list_a" {
  type    = list(string)
  default = ["foo", "bar", "baz"]
}

output "list" {
  value = var.list_a
}

output "list_indexing" {
  value = element(var.list_a, 1)
}

output "list_length" {
  value = length(var.list_a)
}


# set(<TYPE>)
variable "my_set" {
  type    = set(number)
  default = [7, 2, 2]
}

variable "my_list" {
  type    = list(string)
  default = ["foo", "bar", "foo"]
}

output "my_set" {
  value = var.my_set
}

output "my_list" {
  value = var.my_list
}

output "list_as_set" {
  value = toset(var.my_list)
}

# tuple([<TYPE>, …])
variable "my_tup" {
  type    = tuple([number, string, bool])
  default = [4, "hello", false]
}

output "tup" {
  value = var.my_tup
}


# map(<TYPE>)
variable "my_map" {
  type = map(number)
  default = {
    "alpha" = 2
    "bravo" = 3
  }
}

output "map" {
  value = var.my_map
}

output "alpha_value" {
  value = var.my_map["alpha"]
}

# object()
variable "person" {
  type = object({ name = string, age = number })
  default = {
    name = "Bob"
    age  = 10
  }
}

output "person" {
  value = var.person
}

variable "person_with_address" {
  type = object({ name = string, age = number,
    address = object({ line1 = string, line2 = string,
  county = string, postcode = string }) })
  default = {
    name = "Jim"
    age  = 21
    address = {
      line1    = "1 the road"
      line2    = "St Ives"
      county   = "Cambridgeshire"
      postcode = "CB1 2GB"
    }
  }
}

output "person_with_address" {
  value = var.person_with_address
}


# Any Type
variable "any_example" {
  type = any
  default = {
    field1 = "foo"
    field2 = "bar"
  }
}

output "any_example" {
  value = var.any_example
}