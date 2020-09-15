locals {
    env_to_create = {
        "dev" = 1
        "stage" = 1
        "first" = 2
    }
}


resource "aws_sns_topic" "user_updates_list" {
  count = lookup(local.env_to_create, terraform.workspace, 0)
  name = "${terraform.workspace}-multiple-env-specific-topic-${count.index}"
}