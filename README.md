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

### Welcome to CIEM GCP Onboarding!

Steps to onboard a GCP project:
  1. Please paste the environment vars from the MCIEM CloudKnox portal
  
  1. Execute the following command:
     ``` 
     gcloud auth login 
     ```
  
  1. Copy the export parameters from CloudKnox Permission Management Portal for Workload Identity

  
  1. Execute the script to create the provider:
     ``` 
     sh mciem-workload-identity-pool.sh 
     ```
  
  1. Copy the export parameters from CloudKnox Permission Management Portal for Project Onboarding
  
  
  1. Execute the script to onboard the projects:
     ``` 
     sh mciem-member-projects.sh 
     ```
