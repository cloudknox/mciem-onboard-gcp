```


 ██████╗      ██████╗    ██████╗ 
██╔════╝     ██╔════╝    ██╔══██╗
██║  ███╗    ██║         ██████╔╝
██║   ██║    ██║         ██╔═══╝ 
╚██████╔╝    ╚██████╗    ██║     
 ╚═════╝      ╚═════╝    ╚═╝     
                                

 ██████  ███    ██ ██████   ██████   █████  ██████  ██████  
██    ██ ████   ██ ██   ██ ██    ██ ██   ██ ██   ██ ██   ██ 
██    ██ ██ ██  ██ ██████  ██    ██ ███████ ██████  ██   ██ 
██    ██ ██  ██ ██ ██   ██ ██    ██ ██   ██ ██   ██ ██   ██ 
 ██████  ██   ████ ██████   ██████  ██   ██ ██   ██ ██████  


```                                                                                         

### Welcome to CloudKnox Permission Management (CIEM) GCP Onboarding!

Steps to onboard a GCP project:
  1. Please paste the environment vars from the CIEM portal
  
  1. Execute the following command:
     ``` 
     gcloud auth login 
     ```
  
  1. Execute the script to create the provider:
     ``` 
     sh mciem-workload-identity-pool.sh 
     ```
  
  1. Execute the script to onboard the projects:
     ``` 
     sh mciem-member-projects.sh 
     ```
  
  1. Optionally, enable all the recommended GCP APIs:
     ``` 
     sh mciem-enable-gcp-api.sh
     ```
