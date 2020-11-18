################################################################################1
# This file orders a certificate and then loads it into the CMS instance. A commented
# block provides for refreshing the certificate. please refer to this note in ibm 
# cloud docs for ordering/verification when ordering.
# Order certs: https://cloud.ibm.com/docs/services/certificate-manager?topic=certificate-manager-ordering-certificates&locale=en-us
################################################################################

################################################################################
# Create and Import ssl cert for testing and load certificate to CMS
################################################################################

resource "null_resource" "import_certificate" {
  provisioner "local-exec" {
    command = <<EOT

API_KEY=${var.ibmcloud_apikey}
REGION=${var.region}    
CMS_ID=${ibm_resource_instance.cms.id}
HOST_NAME=${ibm_is_lb.lb.hostname}

URL_ENCODED_CMS_ID=$(echo $CMS_ID | sed 's/:/%3A/g' | sed 's/\//%2F/g')

TOKEN=$(echo $(curl -k -X POST \
      --header "Content-Type: application/x-www-form-urlencoded" \
      --data-urlencode "grant_type=urn:ibm:params:oauth:grant-type:apikey" \
      --data-urlencode "apikey=$API_KEY" \
      "https://iam.cloud.ibm.com/identity/token") | jq  -r .access_token)

URL_ENCODED_CMS_ID=$(echo $CMS_ID | sed 's/:/%3A/g' | sed 's/\//%2F/g')

sudo openssl req -x509 -newkey rsa:1024 -keyout private.key -out cert.pem -days 1 -nodes -subj "/C=us/ST=$REGION/L=Dal-10/O=IBM/OU=CloudCerts/CN=$HOST_NAME" 

CERT_DATA=$(tr '\n' '?' < cert.pem | sed 's/?/\\n/g')
PRIV_KEY=$(tr '\n' '?' < private.key | sed 's/?/\\n/g')
 
CERT=$(curl -X POST https://$REGION.certificate-manager.cloud.ibm.com/api/v3/$URL_ENCODED_CMS_ID/certificates/import \
            -H 'Content-Type: application/json' \
            -H "authorization: Bearer $TOKEN" \
            -d "{\"name\":\"$HOST_NAME\",\"description\":\"my cert description\",\"data\":{\"content\":\"$CERT_DATA\", \"priv_key\":\"$PRIV_KEY\"}}")

echo $CERT | jq -r ._id | tr -d '\n' >> cert/cert_id.txt
echo $CERT >> cert/cert.txt

   EOT
  }
  depends_on = [ibm_resource_instance.cms, ibm_is_lb.lb]
}

################################################################################


################################################################################
# Cert reference
################################################################################

data "null_data_source" "cert_id" {

  inputs = {
     openssl_cert = file("${path.module}/cert/cert_id.txt")
  }

  depends_on = [null_resource.import_certificate]

}

################################################################################
