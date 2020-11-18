# This terraform file defines the terraform provider that will be used
# to deploy this architecture. In this case, the IBM Cloud provider is
# the only provider that will be used. The two variables provide the
# means to deploy workloads. However, the APIkey and ibmid must have
# the permissions to deploy this archiecture's resources.

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_apikey
  region           = var.region
  resource_group   = var.resource_group
}

#provider "ibm" {
#  ibmcloud_api_key   = "${var.ibmcloud_apikey}"
#  softlayer_username = "${var.classiciaas_username}"
#  softlayer_api_key  = "${var.classiciaas_apikey}"
#  region             = "${var.region}"
#  generation         = 1
#  ibmcloud_timeout   = 60
#}

##############################################################################

