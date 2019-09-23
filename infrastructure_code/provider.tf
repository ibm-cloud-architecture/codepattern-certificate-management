##############################################################################
# ibm cloud provider data
##############################################################################

provider "ibm" {
  ibmcloud_api_key   = "${var.ibmcloud_apikey}"
  softlayer_username = "${var.classiciaas_username}"
  softlayer_api_key  = "${var.classiciaas_apikey}"
  region             = "${var.region}"
  generation         = 1
  ibmcloud_timeout   = 60
}

##############################################################################


##############################################################################
# Resource Group
##############################################################################

data "ibm_resource_group" "group" {
  name = "${var.resource_group}"
}

##############################################################################