variable "env" {
  type = string
  description = "name of the environments"
  default = "dev"
}

variable "instance" {

}

variable "webserver_port" {
    type = number
}

variable "cidr" {
    type = list(string)
}