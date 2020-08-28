variable "openstack_image_id" {
  description = "The ID of the image to be used for deploy operations."
}

variable "openstack_flavor_id" {
  description = "The ID of the flavor to be used for deploy operations."
}

variable "openstack_network_name" {
  description = "The name of the network to be used for deploy operations."
}

variable "image_id_username" {
  description = "The username to SSH into image ID"
}

variable "image_id_password" {
  description = "The password of the username to SSH into image ID"
}
variable "pool" {
  default = "VLAN354"
}
variable "ibm_stack_name" {
  description = "Stack Name"
}

provider "openstack" {
  insecure = true
  version  = "~> 0.3"
}

#variable "number_of_instances" {}

resource "openstack_compute_instance_v2" "single-vm" {
  count     = "${var.number_of_instances}"
  name      = "${var.ibm_stack_name}${format("-vm-%02d", count.index+1)}"
  image_id  = "${var.openstack_image_id}"
  flavor_id = "${var.openstack_flavor_id}"   

  network {
    name = "${var.openstack_network_name}"
    #fixed_ip_v4 = "${var.openstack_network_ip}"
  }

  # Specify the ssh connection
 connection {
 user     = "${var.image_id_username}"
 password = "${var.image_id_password}"
 timeout  = "10m"
  }
}
#resource "openstack_networking_router_v2" "terraform" {
#name = "terraform"
#admin_state_up = "true"
#external_gateway = "10.3.54.254"
#}

#get address from the pool
#resource "openstack_networking_router_interface_v2" "terraform" {
#router_id = "${openstack_networking_router_v2.terraform.id}"
##subnet_id = "${openstack_networking_subnet_v2.terraform.id}"
#}
#resource "openstack_compute_floatingip_v2" "terraform" {
#pool = "${var.pool}"
#depends_on = ["openstack_networking_router_interface_v2.terraform"]
#}

output "single-vm-ip" {
  value = "${openstack_compute_instance_v2.single-vm.*.network.0.fixed_ip_v4}"
 # value = "${openstack_compute_floatingip_v2.terraform.address}"
}
