#!/bin/bash -ux
export MCIEM_CUSTOM_ROLE_NAME=CloudKnoxIAMOrgAdmin

if [ -z "$GCP_COLLECTION_ORG_ID" ] && [ -z "$GCP_COLLECTION_FOLDER_IDS" ] && [ -z "$GCP_COLLECTION_PROJECT_IDS" ]; then
  echo "You have to set either GCP_COLLECTION_ORG_ID, GCP_COLLECTION_FOLDER_IDS or GCP_COLLECTION_PROJECT_IDS"
  exit 1
fi

read -p "Enable controller. Enter 'y' or 'n'. More info at https://aka.ms/ciem-enable-controller: " MCIEM_GCP_ENABLE_CONTROLLER
export MCIEM_GCP_ENABLE_CONTROLLER=${MCIEM_GCP_ENABLE_CONTROLLER:-n}

if [ $MCIEM_GCP_ENABLE_CONTROLLER = 'y' ] ; then
  if [ ! -z "$GCP_COLLECTION_ORG_ID" ] || [ ! -z "$GCP_COLLECTION_FOLDER_IDS" ] ; then
    if [ -z "$GCP_COLLECTION_ORG_ID" ]; then
      echo "You have to set GCP_COLLECTION_ORG_ID"
      exit 1
    fi

    FILE=./cloudknox-iam-org-admin.yaml
    if [ ! -f "$FILE" ]; then
      echo "$FILE do not exists."
      exit 1
    fi

    read -p "Enter Custom Role Name. Default CloudKnoxIAMOrgAdmin. More info at https://aka.ms/ciem-enable-controller: " MCIEM_CUSTOM_ROLE_NAME
    export MCIEM_CUSTOM_ROLE_NAME=${MCIEM_CUSTOM_ROLE_NAME:-CloudKnoxIAMOrgAdmin}

    echo "Creating ${MCIEM_CUSTOM_ROLE_NAME} Custom Role"
    gcloud iam roles create ${MCIEM_CUSTOM_ROLE_NAME} --organization=${GCP_COLLECTION_ORG_ID} --file=$FILE
  fi
fi

export GCP_OIDC_PROJECT_ID=$(gcloud projects list --filter="PROJECT_NUMBER=$GCP_OIDC_PROJECT_NUMBER" --format="value(projectId)")

echo Adding permissions to projects $GCP_COLLECTION_PROJECT_IDS and set controller flag to $MCIEM_GCP_ENABLE_CONTROLLER
for GCP_COLLECTION_PROJECT_ID in $(echo $GCP_COLLECTION_PROJECT_IDS | tr "," "\n"); do

  export GCP_COLLECTION_PROJECT_NAME=$(gcloud projects list --filter="projectId=$GCP_COLLECTION_PROJECT_ID" --format="value(projectName)")
  export GCP_COLLECTION_PROJECT_NUMBER=$(gcloud projects list --filter="projectId=$GCP_COLLECTION_PROJECT_ID" --format="value(projectNumber)")

  echo Working on project name:$GCP_COLLECTION_PROJECT_NAME number:$GCP_COLLECTION_PROJECT_NUMBER id:$GCP_COLLECTION_PROJECT_ID

  echo Adding IAM policy binding iam.securityReviewer to ${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_PROJECT_ID}.iam.gserviceaccount.com 
  gcloud projects add-iam-policy-binding ${GCP_COLLECTION_PROJECT_ID} \
    --member="serviceAccount:${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/iam.securityReviewer"

  echo Adding Viewer Role to ${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_PROJECT_ID}.iam.gserviceaccount.com 
  gcloud projects add-iam-policy-binding ${GCP_COLLECTION_PROJECT_ID} \
    --member="serviceAccount:${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/viewer"

  if [ $MCIEM_GCP_ENABLE_CONTROLLER = 'y' ];
  then
    echo Enabling controller for account $GCP_COLLECTION_PROJECT_ID
    echo Adding IAM policy binding iam.securityAdmin to ${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_PROJECT_ID}.iam.gserviceaccount.com 
    gcloud projects add-iam-policy-binding ${GCP_COLLECTION_PROJECT_ID} \
      --member="serviceAccount:${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_PROJECT_ID}.iam.gserviceaccount.com" \
      --role="roles/iam.securityAdmin"
    
    echo Adding IAM policy binding iam.roleAdmin to ${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_PROJECT_ID}.iam.gserviceaccount.com 
    gcloud projects add-iam-policy-binding ${GCP_COLLECTION_PROJECT_ID} \
      --member="serviceAccount:${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_PROJECT_ID}.iam.gserviceaccount.com" \
      --role="roles/iam.roleAdmin"
  fi  
done

echo Addinging permissions to folders $GCP_COLLECTION_FOLDER_IDS and set controller flag to $MCIEM_GCP_ENABLE_CONTROLLER
for GCP_COLLECTION_FOLDER_ID in $(echo $GCP_COLLECTION_FOLDER_IDS | tr "," "\n"); do
  echo Adding IAM policy binding iam.securityReviewer to ${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_FOLDER_ID}.iam.gserviceaccount.com
  gcloud resource-manager folders add-iam-policy-binding ${GCP_COLLECTION_FOLDER_ID} \
      --member="serviceAccount:${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_PROJECT_ID}.iam.gserviceaccount.com" \
      --role="roles/iam.securityReviewer"

  echo Adding Viewer Role to ${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_PROJECT_ID}.iam.gserviceaccount.com 
  gcloud resource-manager folders add-iam-policy-binding ${GCP_COLLECTION_FOLDER_ID} \
    --member="serviceAccount:${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/viewer"

  if [ $MCIEM_GCP_ENABLE_CONTROLLER = 'y' ];
  then
    echo Enabling controller for folder $GCP_COLLECTION_FOLDER_ID
    echo Adding IAM policy binding iam.securityAdmin to ${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_PROJECT_ID}.iam.gserviceaccount.com 
    gcloud resource-manager folders add-iam-policy-binding ${GCP_COLLECTION_FOLDER_ID} \
      --member="serviceAccount:${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_PROJECT_ID}.iam.gserviceaccount.com" \
      --role="roles/iam.securityAdmin"
    
    echo Adding IAM policy binding ${MCIEM_CUSTOM_ROLE_NAME} to ${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_PROJECT_ID}.iam.gserviceaccount.com 
    gcloud resource-manager folders add-iam-policy-binding ${GCP_COLLECTION_FOLDER_ID} \
      --member="serviceAccount:${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_PROJECT_ID}.iam.gserviceaccount.com" \
      --role="organizations/${GCP_COLLECTION_ORG_ID}/roles/${MCIEM_CUSTOM_ROLE_NAME}"
  fi  

done

echo Adding permissions to org $GCP_COLLECTION_ORG_ID and set controller flag to $MCIEM_GCP_ENABLE_CONTROLLER
if  [ ! -z "$GCP_COLLECTION_ORG_ID" ]; then 
  
  read -p "Add role policy to organization. Enter 'y' or 'n'. More info at https://aka.ms/ciem-enable-controller: " MCIEM_ADD_ROLE_AT_ORG_LEVEL
  export MCIEM_ADD_ROLE_AT_ORG_LEVEL=${MCIEM_ADD_ROLE_AT_ORG_LEVEL:-n}
  if [ ! $MCIEM_ADD_ROLE_AT_ORG_LEVEL = 'y' ] ; then
    echo Skipping adding role policy to organization
    exit 0
  fi

  echo Adding IAM policy binding iam.securityReviewer to ${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_ORG_ID}.iam.gserviceaccount.com
  gcloud organizations add-iam-policy-binding ${GCP_COLLECTION_ORG_ID} \
      --member="serviceAccount:${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_PROJECT_ID}.iam.gserviceaccount.com" \
      --role="roles/iam.securityReviewer"

  echo Adding Viewer Role to ${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_PROJECT_ID}.iam.gserviceaccount.com 
  gcloud organizations add-iam-policy-binding ${GCP_COLLECTION_ORG_ID} \
    --member="serviceAccount:${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/viewer"

  if [ $MCIEM_GCP_ENABLE_CONTROLLER = 'y' ];
  then
    echo Enabling controller for folder $GCP_COLLECTION_ORG_ID
    echo Adding IAM policy binding iam.securityAdmin to ${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_PROJECT_ID}.iam.gserviceaccount.com 
    gcloud organizations add-iam-policy-binding ${GCP_COLLECTION_ORG_ID} \
      --member="serviceAccount:${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_PROJECT_ID}.iam.gserviceaccount.com" \
      --role="roles/iam.securityAdmin"
    
    echo Adding IAM policy binding ${MCIEM_CUSTOM_ROLE_NAME} to ${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_PROJECT_ID}.iam.gserviceaccount.com 
    gcloud organizations add-iam-policy-binding ${GCP_COLLECTION_ORG_ID} \
      --member="serviceAccount:${GCP_OIDC_SERVICE_ACCOUNT_NAME}@${GCP_OIDC_PROJECT_ID}.iam.gserviceaccount.com" \
      --role="organizations/${GCP_COLLECTION_ORG_ID}/roles/${MCIEM_CUSTOM_ROLE_NAME}"
  fi
fi