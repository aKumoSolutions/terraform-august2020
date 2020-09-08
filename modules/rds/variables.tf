variable "env" {
  default = "default"
}

variable "skip_snapshot" {
  default = true
}

variable "schema_name" {
  default = "rds-users"
}

variable "storage" {

}

variable "cidr" {
  type = list(string)
}

variable "instance_class" {}