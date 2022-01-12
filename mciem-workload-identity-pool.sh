#!/bin/bash -ux

export GCP_OIDC_PROJECT_NAME=$(gcloud projects list --filter="PROJECT_NUMBER=$GCP_OIDC_PROJECT_NUMBER" --format="value(projectName)")
export GCP_OIDC_PROJECT_ID=$(gcloud projects list --filter="PROJECT_NUMBER=$GCP_OIDC_PROJECT_NUMBER" --format="value(projectId)")

gcloud config set project $GCP_OIDC_PROJECT_ID

echo In project name:$GCP_OIDC_PROJECT_NAME number:$GCP_OIDC_PROJECT_NUMBER id:$GCP_OIDC_PROJECT_ID

echo Create workload identity pool ${GCP_OIDC_WIP_ID}
gcloud iam workload-identity-pools \
  create ${GCP_OIDC_WIP_ID} \
  --location="global" \
  --description="ms-ciem-workload-identity-pool" \
  --display-name="ms-ciem-workload-identity-pool"

echo Create workload identity pool provider ${GCP_OIDC_WIP_PROVIDER_ID}
gcloud iam workload-identity-pools providers \
  create-oidc ${GCP_OIDC_WIP_PROVIDER_ID} \
  --location=global \
  --description="ms-ciem-workload-identity-pool-provider" \
  --display-name="ms-ciem-workload-identity-pool-provider"
  --workload-identity-pool="${GCP_OIDC_WIP_ID}" \
  --issuer-uri="https://${AZURE_AUTHORITY_URL}/${AZURE_TENANT_ID}/" \
  --allowed-audiences="api://mciem-gcp-oidc-app" \
  --attribute-condition="attribute.appid==\"${AZURE_APP_ID}\"" \
  --attribute-mapping="google.subject=assertion.sub, attribute.tid=assertion.tid"


echo Create IAM service account ${GCP_OIDC_SERVICE_ACCOUNT_NAME}
gcloud iam service-accounts \
  create ${GCP_OIDC_SERVICE_ACCOUNT_NAME} \
  --description="ms-ciem-service-account" \
  --display-name="ms-ciem-service-account"

echo Add IAM policy binding for iam.workloadIdentityUser to ${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_PROJECT_ID}.iam.gserviceaccount.com 
gcloud iam service-accounts \
  add-iam-policy-binding projects/${GCP_OIDC_PROJECT_ID}/serviceAccounts/${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/iam.workloadIdentityUser \
  --member "principalSet://iam.googleapis.com/projects/${GCP_OIDC_PROJECT_NUMBER}/locations/global/workloadIdentityPools/${GCP_OIDC_WIP_ID}/*"
