#!/bin/bash -x

export GCP_OIDC_PROJECT_NUMBER=<GCP_OIDC_PROJECT_NUMBER>
export GCP_OIDC_SERVICE_ACCOUNT_NAME=<GCP_OIDC_SERVICE_ACCOUNT_NAME>
export GCP_COLLECTION_PROJECT_IDS=(<GCP_COLLECTION_PROJECT_IDS>)
export GCP_OIDC_PROJECT_ID=$(gcloud projects list --filter="Name=$GCP_OIDC_PROJECT_NUMBER" --format="value(projectId)")



for GCP_COLLECTION_PROJECT_ID in "${GCP_COLLECTION_PROJECT_IDS[@]}"; do

  export GCP_COLLECTION_PROJECT_NAME=$(gcloud projects list --filter="projectId=$GCP_COLLECTION_PROJECT_ID" --format="value(projectName)")
  export GCP_COLLECTION_PROJECT_NUMBER=$(gcloud projects list --filter="projectId=$GCP_COLLECTION_PROJECT_ID" --format="value(projectNumber)")

  echo Working on project name:$GCP_COLLECTION_PROJECT_NAME number:$GCP_COLLECTION_PROJECT_NUMBER id:$GCP_COLLECTION_PROJECT_ID

  echo Add IAM policy binding for iam.securityReviewer to ${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_PROJECT_ID}.iam.gserviceaccount.com 
  gcloud projects add-iam-policy-binding ${GCP_COLLECTION_PROJECT_ID} \
    --member="serviceAccount:${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/iam.securityReviewer"

  echo Add IAM policy binding for viewer to ${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_PROJECT_ID}.iam.gserviceaccount.com 
  gcloud projects add-iam-policy-binding ${GCP_COLLECTION_PROJECT_ID} \
    --member="serviceAccount:${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/viewer"

  echo Add IAM policy binding for iam.securityAdmin to ${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_PROJECT_ID}.iam.gserviceaccount.com 
  gcloud projects add-iam-policy-binding ${GCP_COLLECTION_PROJECT_ID} \
    --member="serviceAccount:${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/iam.securityAdmin"
done
