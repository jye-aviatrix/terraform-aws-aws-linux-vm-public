variable "region" {
  description = "Provide region of the VM"
  type        = string
  nullable    = false
}

variable "vm_name" {
  description = "Provide name of the VM. The VM name will be added to tags by default"
  type        = string
  nullable    = false
}

variable "tags" {
  description = "Provide additional tags"
  default     = {}
  type        = map(string)
}

locals {
  description = "By default, VM name will be added. Additional tags will be merge with the VM name tag"
  tags = merge(
    {
      Name = var.vm_name
    },
    var.tags
  )
}

variable "vpc_id" {
  type        = string
  description = "Provide VPC id"
  nullable    = false
}

variable "subnet_id" {
  type        = string
  description = "Provide public subnet id"
  nullable    = false
}

variable "key_name" {
  type        = string
  description = "Provide regional key pair name for launch VM"
  nullable    = false
}

variable "use_eip" {
  type        = bool
  description = "Choose whether to use EIP or not"
  default     = false
}





