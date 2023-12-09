# GitOps on GCP
---

## Objective
* To build GitOps deployment on GCP 

## Architecture Diagram

---
| Prerequisite
* Google Cloud Account
* Project Owner Role

```sh
# Build the infrastructure
source environment-variables.sh
sh infrastructure-automation.sh

# GitOps Instructions
# GitOps-on-GCP.sh

# Cleanup
source environment-variables.sh
sh cleanup.sh
```
---
Resource:
* Git Repository: https://github.com/mregojos/GitOps-on-GCP