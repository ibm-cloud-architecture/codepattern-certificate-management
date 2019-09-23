
##############################################################################
# Account Variables
##############################################################################

variable classiciaas_apikey {
  description = "The Infrastructure API Key needed to deploy all IaaS resources"
  default     = ""
}

variable classiciaas_username {
  description = "The IBM Cloud classic infrastructure username (email)"
  default     = ""
}

variable ibmcloud_apikey {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
  default     = ""
}

variable account_id {
  description = "Account ID, obtain in UI under manage/account/account settings/ID:"
  default     = ""
}

variable ssh_key {
  description = "ssh public key that will be assigned to each VSI. Ensure no extra spaces"
  default     = ""
}

variable region {
  description = "IBM Cloud region where all resources will be deployed"
  default     = "eu-gb"
}

variable resource_group {
  description = "the name of the resource group used for all resources. "
  default     = ""
}

variable unique_id {
  description = "a unique id that could be included in naming of all resources. No caps or _ must be at least one character"
  default     = ""
}


##############################################################################


##############################################################################
# VSI Variables
##############################################################################

variable image_template_id {
  description = "Image template id used for vsi. `ubuntu 18.04`"
  default     = "cfdaf1a0-5350-4350-fcbc-97173b510843"
}


variable machine_type {
  description = "Machine type used while provisioning vsi"
  default     = "cc1-2x4"
}

variable tags {
  description = "Tags used on resources"
  default     = ["tag1", "tag2"]
}

variable private_key {
  description = "escaped certs private key"
  default     = ""
}

variable certs_content {
  description = "escaped certs content"
  default     = ""
}

variable access_roles {
  default = ["Manager"]
}
variable access_members {
  default = ["Jennifer.Valle@ibm.com"]
}

variable access_group {
  default = "Managers"
}
