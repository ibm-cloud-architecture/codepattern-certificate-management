##############################################################################
# This file creates a VPC, zone
# and subnets to demonstrate LBaaS and CMS integration
##############################################################################


# Create the Resource Group that is used when deploying the VPC
resource "ibm_resource_group" "group" {
  name = var.resource_group
}

##############################################################################
# Create ssh key for all virtual servers.
##############################################################################

resource "ibm_is_ssh_key" "ssh" {
  name       = "ssh-${var.unique_id}"
  public_key = var.ssh_key
}

##############################################################################


##############################################################################
# Create a VPC
##############################################################################

resource "ibm_is_vpc" "vpc" {
  name           = "vpc-${var.unique_id}"
  classic_access = false
  resource_group = ibm_resource_group.group.id
}

##############################################################################


##############################################################################
# Create address prefix for one zone
##############################################################################

resource "ibm_is_vpc_address_prefix" "vpc_prefix" {
  name = "vpc-prefix-${var.unique_id}"
  zone = "${var.region}-1"
  vpc  = ibm_is_vpc.vpc.id
  cidr = "10.10.1.0/24"
}

##############################################################################


##############################################################################
# Creates a public subnet in the zone
##############################################################################

resource "ibm_is_subnet" "subnet" {
  name            = "vpc-subnet-${var.unique_id}"
  vpc             = ibm_is_vpc.vpc.id
  zone            = "${var.region}-1"
  ipv4_cidr_block = "10.10.1.0/24"
  depends_on      = [ibm_is_vpc_address_prefix.vpc_prefix]
}

##############################################################################
# Create a vsi for the subnet and pool membership
##############################################################################

resource "ibm_is_instance" "vsi" {

  name    = "vsi-${var.unique_id}"
  image   = var.image_template_id
  profile = var.machine_type
  vpc     = ibm_is_vpc.vpc.id
  zone    = "${var.region}-1"
  keys    = [ibm_is_ssh_key.ssh.id]

  primary_network_interface {
    name   = "network-if"
    subnet = ibm_is_subnet.subnet.id
  }

}

##############################################################################
