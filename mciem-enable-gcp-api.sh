#!/bin/bash -ux

export GCP_APIS_TO_ENABLE=(admin.googleapis.com cloudresourcemanager.googleapis.com cloudapis.googleapis.com compute.googleapis.com iam.googleapis.com iamcredentials.googleapis.com logging.googleapis.com stackdriver.googleapis.com recommender.googleapis.com storage-api.googleapis.com storage-component.googleapis.com dataproc.googleapis.com pubsub.googleapis.com container.googleapis.com datastore.googleapis.com spanner.googleapis.com redis.googleapis.com memcache.googleapis.com sql-component.googleapis.com sqladmin.googleapis.com bigtable.googleapis.com bigtableadmin.googleapis.com appengine.googleapis.com bigquery-json.googleapis.com cloudbuild.googleapis.com clouddebugger.googleapis.com cloudtrace.googleapis.com containerregistry.googleapis.com deploymentmanager.googleapis.com ml.googleapis.com monitoring.googleapis.com oslogin.googleapis.com replicapool.googleapis.com replicapoolupdater.googleapis.com resourceviews.googleapis.com servicemanagement.googleapis.com memcache.googleapis.com redis.googleapis.com)

echo Enabling list of recommended APIs for CloudKnox Permissions Management 

for GCP_COLLECTION_PROJECT_ID in $(echo $GCP_COLLECTION_PROJECT_IDS | tr "," "\n"); do

  echo Setting config scope to project $GCP_COLLECTION_PROJECT_ID  
  gcloud config set project $GCP_COLLECTION_PROJECT_ID
  
  for API in "${GCP_APIS_TO_ENABLE[@]}"; do
    echo Enabling API $API
    gcloud services enable $API
  done
done
