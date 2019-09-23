################################################################################
# Create an IAM authorization policy for LBaaS to read the CMS instance
# policy will be destroy on deletion of the instances. 
################################################################################

resource "null_resource" "cms_service_policy_for_lbaas" {
  provisioner "local-exec" {
    command = <<EOT

TOKEN=$(echo $(curl -k -X POST \
      --header "Content-Type: application/x-www-form-urlencoded" \
      --data-urlencode "grant_type=urn:ibm:params:oauth:grant-type:apikey" \
      --data-urlencode "apikey=${var.ibmcloud_apikey}" \
      "https://iam.cloud.ibm.com/identity/token") | jq -r .access_token)


ACCOUNT_ID=${var.account_id}
SUBJECT_NAME=is
SUBJECT_ID=${ibm_is_lb.lb.id}
RESOURCE_NAME=cloudcerts
RESOURCE_ID=${element(split(":", ibm_resource_instance.cms.id), 7)}
REGION=${var.region}

curl -X POST \
"https://iam.cloud.ibm.com/v1/policies" \
-H "Authorization: Bearer $TOKEN" \
-H 'Content-Type: application/json' \
-d '{
  "type": "authorization",
  "subjects": [
    {
      "attributes": [
        { 
          "name": "accountId",
          "value": "'$ACCOUNT_ID'"
        },
        {
          "name": "region",
          "value": "'$REGION'"
        },        
        {
          "name": "serviceName",
          "value": "'$SUBJECT_NAME'"
        },
        {
          "name": "serviceInstance",
          "value": "'$SUBJECT_ID'"
        },
        {
          "name": "resourceType",
          "value": "load-balancer"
        }
      ]
    }
  ],
  "roles":[
    {
      "role_id": "crn:v1:bluemix:public:iam::::serviceRole:Writer"
    },
    {
      "role_id": "crn:v1:bluemix:public:iam::::serviceRole:Reader"
    }
  ],
  "resources":[
    {  
      "attributes": [
        { 
          "name": "accountId",
          "value": "'$ACCOUNT_ID'"
        },
        {
          "name": "serviceName",
          "value": "'$RESOURCE_NAME'"
        }
      ]
    }
  ]
}' | jq

# echo $KEY >> config/lbaas_policy_id.txt
    
EOT

  }

  depends_on = ["ibm_is_lb.lb", "null_resource.import_certificate"]
}

################################################################################


################################################################################
# It will create access group, add user to group and add policies. 
# On terraform destroy it will delete the group, remove user and delete policies.
################################################################################


################################################################################
# Add CMS Access policies
################################################################################

resource "ibm_iam_access_group" "access_group" {
  name = "${var.access_group}"
}


resource "ibm_iam_access_group_members" "manager_access_members" {
  access_group_id = "${ibm_iam_access_group.access_group.id}"
  ibm_ids         = "${var.access_members}"
}

resource "ibm_iam_access_group_policy" "policy" {

  access_group_id = "${ibm_iam_access_group.access_group.id}"
  roles           = "${var.access_roles}"

  resources = [{
    service              = "cloudcerts"
    resource_instance_id = "${element(split(":", ibm_resource_instance.cms.id), 7)}"
  }]

}

################################################################################