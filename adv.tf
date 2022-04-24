# ------ COUNT - Create multiple resources
# can use this to create a resource optionally
resource "aws_sqs_queue" "queues" {
  count = 4
  name  = "queue-${count.index}"
}

output "queue-0-name" {
  value = aws_sqs_queue.queues[0].name
}


# ------ FOR EACH
# need to use - set / map
locals {
  fruit = toset(["apple", "orange", "banana"])
}

resource "aws_sqs_queue" "queues" {
  for_each = local.fruit
  name     = "queue-${each.key}"
}

output "queue-apple-name" {
  value = aws_sqs_queue.queues["apple"].name
}


# Life cycle

resource "aws_s3_bucket" "first_bucket" {
  bucket = "vatadepalli-first-bucket"

  lifecycle {
    # create_before_destroy = true
    # prevent_destroy = true
  }
}

resource "aws_sqs_queue" "queue" {
  name = "queue"
  lifecycle {
    # prevent_destroy = true
    # ignore_changes = true
  }
}


# DEPENDS ON

resource "aws_iam_role_policy" "policy" {
  name = "policy"
  role = "role"
  policy = jsonencode({
    "Statement" = [{
      "Action" = "s3:*",
      "Effect" = "Allow",
    }],
  })
}

resource "aws_instance" "example" {
  ami           = "ami-a1b2c3d4"
  instance_type = "t2.micro"
  depends_on = [
    aws_iam_role_policy.policy,
  ]
}
