```
   _____    _____   _____       ____    _   _   ____     ____               _____    _____  
  / ____|  / ____| |  __ \     / __ \  | \ | | |  _ \   / __ \      /\     |  __ \  |  __ \ 
 | |  __  | |      | |__) |   | |  | | |  \| | | |_) | | |  | |    /  \    | |__) | | |  | |
 | | |_ | | |      |  ___/    | |  | | | . ` | |  _ <  | |  | |   / /\ \   |  _  /  | |  | |
 | |__| | | |____  | |        | |__| | | |\  | | |_) | | |__| |  / ____ \  | | \ \  | |__| |
  \_____|  \_____| |_|         \____/  |_| \_| |____/   \____/  /_/    \_\ |_|  \_\ |_____/ 
```                                                                                         

### Welcome to CIEM GCP Onboarding!

Steps to onboard a GCP project:
  1. Please paste the environment vars from the MCIEM CloudKnox portal
  
  1. Execute the following command:
     ``` gcloud auth login ```
  1. Execute the script to create the provider:
    ``` sh mciem-workload-identity-pool.sh ```
  1. Execute the script to onboard the projects:
    ``` sh mciem-member-projects.sh ```
