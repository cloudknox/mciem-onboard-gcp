#!/bin/bash -ux

export OIDC_POOL_NAME=replace_oidc_pool_name
export OIDC_PROVIDER_NAME=replace_oidc_pool_name

#must be between 6 to 30 character
export SERVICE_ACCOUNT_NAME=replace_service_account_name
#export PROJECT_NAME=replace_project_name

export PROJECT_NUMBER=replace_project_name

export GCLOUD_PATH=/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin

/bin/bash -c "$(curl -fsSL https://mciem.s3.us-east-2.amazonaws.com/gcp/mciem-workload-identity.sh)"

/bin/bash -c "$(curl -fsSL https://mciem.s3.us-east-2.amazonaws.com/gcp/mciem-member-account.sh)"

