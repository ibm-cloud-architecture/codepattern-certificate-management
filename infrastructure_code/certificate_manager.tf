################################################################################
# This file creates
# - a certificate  manager service (cms) resource instance & resource instace key
# - an IAM authorization with the LBaaS (create in LBaaS file)
# - an access group and assigns the group manager access
# - a SSL certificate and loads the certificate to the instance
# - commented refresh of certificate
################################################################################

resource "ibm_resource_instance" "cms" {

  name              = "cms-${var.unique_id}"
  service           = "cloudcerts"
  plan              = "free"
  location          = "${var.region}"
  tags              = "${var.tags}"
  resource_group_id = "${data.ibm_resource_group.group.id}"
  
  parameters = {
    "HMAC"            = true,
    service-endpoints = "public"
  }

}

################################################################################