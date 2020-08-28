#####################################################################
##
##      Created 8/27/20 by IBMDemo. for test
##
#####################################################################
provider "openstack" {
  insecure = true
  #version  = "~> 0.3"
}

variable "openstack_image_name" {
  type = "string"
  description = "The Name of the image to be used for deploy operations."
}

variable "openstack_flavor_name" {
  type = "string"
  description = "The Name of the flavor to be used for deploy operations."
}

variable "openstack_network_name" {
  type = "string"
  description = "The name of the network to be used for deploy operations."
}

#variable "image_id_username" {
#  description = "The username to SSH into image ID"
#}

#variable "image_id_password" {
#  description = "The password of the username to SSH into image ID"
#}

#variable "pool" {
#  default = "VLAN354"
#}
variable "ibm_stack_name" {
  description = "Stack Name"
}



#variable "number_of_instances" {}

resource "openstack_compute_instance_v2" "single-vm" {
#  count     = "${var.number_of_instances}"
  name      = "${var.ibm_stack_name}${format("-vm-%02d", count.index+1)}"
  image_id  = "${var.openstack_image_name}"
  flavor_id = "${var.openstack_flavor_name}"   

  network {
    name = "${var.openstack_network_name}"
    #fixed_ip_v4 = "${var.openstack_network_ip}"
  }

  # Specify the ssh connection
#  connection {
#    user     = "${var.image_id_username}"
#    password = "${var.image_id_password}"
#    timeout  = "10m"
#  }
}

output "single-vm-ip" {
  value = "${openstack_compute_instance_v2.single-vm.*.network.0.fixed_ip_v4}"
 # value = "${openstack_compute_floatingip_v2.terraform.address}"
}
