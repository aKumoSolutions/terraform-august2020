resource "aws_s3_bucket" "remote_state" {
  bucket = "terraform-august-state"

  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }
  lifecycle {
      prevent_destroy = true
  }
}
resource "aws_s3_bucket_policy" "state_policy" {
  bucket = aws_s3_bucket.remote_state.id

  policy = data.aws_iam_policy_document.state_policy_document.json
#<<-POLICY
#     {
#     "Id": "Policy1598314203417",
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#         "Action": [
#             "s3:GetObject",
#             "s3:PutObject"
#         ],
#         "Effect": "Allow",
#         "Resource": "${aws_s3_bucket.remote_state.arn}/*",
#         "Principal": {
#             "AWS": [
#             "arn:aws:iam::707493311370:role/terraform"
#             ]
#         }
#         },
#         {
#         "Action": [
#             "s3:ListBucket"
#         ],
#         "Effect": "Allow",
#         "Resource": "${aws_s3_bucket.remote_state.arn}",
#         "Principal": {
#             "AWS": [
#             "arn:aws:iam::707493311370:role/terraform"
#             ]
#         }
#         }
#     ]
#     }
#     POLICY
}

data "aws_iam_policy_document" "state_policy_document" {
  statement {
    sid = "RemoteStatePolicy"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.remote_state.arn}/*",
    ]

    principals {
        type = "AWS"
        identifiers = ["arn:aws:iam::707493311370:role/terraform"]
    }
  }

  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "${aws_s3_bucket.remote_state.arn}",
    ]

    principals {
        type = "AWS"
        identifiers = ["arn:aws:iam::707493311370:role/terraform"]
    }
  }
}