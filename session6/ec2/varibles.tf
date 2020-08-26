variable "env" {
  type = string
  description = "name of the environments"
  default = "dev"
}

variable "instance_type" {

}

variable "webserver_port" {
    type = number
}

variable "cidr" {
    type = list(string)
}