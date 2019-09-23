##############################################################################
# Create a load balancer as a service (lbaas) attached to the subnet
##############################################################################

resource "ibm_is_lb" "lb" {
  name           = "vpc-lb-${var.unique_id}"
  type           = "public"
  subnets        = ["${ibm_is_subnet.subnet.id}"]
  resource_group = "${data.ibm_resource_group.group.id}"

}

##############################################################################


##############################################################################
# Creates a pool for the load balancer listener
##############################################################################

resource "ibm_is_lb_pool" "pool" {
  name           = "pool-${var.unique_id}"
  lb             = "${ibm_is_lb.lb.id}"
  algorithm      = "round_robin"
  protocol       = "http"
  health_delay   = "20"
  health_retries = "3"
  health_timeout = "5"
  health_type    = "http"
}

##############################################################################


##############################################################################
# Creates a listener for the load balancer 
##############################################################################

resource "ibm_is_lb_listener" "listener" {
  lb                   = "${ibm_is_lb.lb.id}"
  port                 = 8443
  protocol             = "https"
  default_pool         = "${ibm_is_lb_pool.pool.id}"
  certificate_instance = "${data.null_data_source.cert_id.outputs["openssl_cert"]}"
  depends_on           = ["null_resource.reg_upload_certs"]
}


##############################################################################


##############################################################################
# Creates a pool member for each of the VSIs
##############################################################################

resource "ibm_is_lb_pool_member" "pool_member" {
  lb             = "${ibm_is_lb.lb.id}"
  pool           = "${ibm_is_lb_pool.pool.id}"
  port           = "80"
  target_address = "${ibm_is_instance.vsi.primary_network_interface.0.primary_ipv4_address}"
  weight         = "50"
}

##############################################################################