# env = dev01-us
# env = dev02-us
# env = stg01-ca
# env = stg01-us

#dev = devowner@test.com
#stg = stgowner@test.com 

variable "env" {}

locals {
    environment = upper(var.env)
    env_lower = lower(local.environment)
    test = "this is test"

    env_type_to_owner = {
        "dev" = "devowner@test.com"
        "stg" = "stgowner@test.com"
        "prd" = "prdowner@test.com"
    }
    env_type = substr(var.env, 0, 3)
    owner = lookup(local.env_type_to_owner, local.env_type, "defowner@test.com")
}

output "tags" {
    value = {
        "Name"        = "${var.env}-webserver"
        "environment" = local.environment
        "env_to_lower" = local.env_lower
        "testTag" = local.test
        "env_type" = upper(substr(var.env, 0, 3))
        "owner" = local.owner
    }
}