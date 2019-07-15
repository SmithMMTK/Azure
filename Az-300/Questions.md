### Questions
---
[ ] - Migrate from AWS to Azure ([detail](https://docs.microsoft.com/en-us/azure/site-recovery/migrate-tutorial-aws-azure))
    >- Prepare Infrastructure
    >    1. Create Storage Account
    >    1. Create Vault
    >    1. Create Virtual Network

---

[ ] - Azure Resource Manager templates ([detail](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-authoring-templates))

    ```json
    {
        "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
        "contentVersion": "",
        "apiProfile": "",
        "parameters": {  },
        "variables": {  },
        "functions": [  ],
        "resources": [  ],
        "outputs": {  }
    }
    ```
    - __parameters__ : Values that are provided when deployment is executed to customize resource deployment.
        ```json
        "parameters": 
        {
            "<parameter-name>" : {
                "type" : "<type-of-parameter-value>",
                "defaultValue": "<default-value-of-parameter>",
                "allowedValues": [ "<array-of-allowed-values>" ],
                "metadata": {
                    "description": "<description-of-the parameter>" 
                }
            }
        }
        ```
    - __variables__ : Values that are used as JSON fragments in the template to simplify template language expressions.
    - __resources__ : Resource types that are deployed or updated in a resource group or subscription.

---

- KQL Heartbeat [x]
    ```KQL
    Heartbeat
    | where TimeGenerated > ago(7d)
    | summarize max(TimeGenerated) by Computer
    | where max_TimeGenerated < ago(1d)
    ```

- KQL Heartbeat [x]
    ```KQL
    Heartbeat
    | where TeimGenerated > ago(1h)
    | summarize distinct_computers = Dcount (Computer) by OSType
    ``` 
    >__Dcount__ = Distinct number of computers
    
---
- Backup all from VMs [x]
    - Create a Recovery Services vault
    - Define a backup policy to protect the VMs
    - Perform the initial backup
---
- az role assignment create --role "App Contributor" assignee-object-id "GUID" [xx]
---
- Azure App Service : Detailed error logs => HTML documents that provide information about HTTP errors [x]
---
- Disable-ADSyncExportDeletionThreshold => Disable the deletion protection (for large volume sync) [x]
---
- Steps to do Hyper-V migration to Azure [x]
    - Create Recovery Services vault
    - Set Protection goal to migration from on-premises to Azure
    - Create a Hyper-V site and add the VM
    - Install Site Recovery Provider on local VM
    - Register the Hyper-V site in the vault
---
- Backing up VM to make a copy of VMs and store the copies for furture repair or rebuild [x]
    - Azure Backup
    - Recovery Services vault
---
- Re-enter credential (in case password expired) => Add-ADSyncAADServiceAccount [o]
---
- Use http://xxx.azurewebsites.net/api/logstream endpoint to track progress information for web app container instances.
---
- Azure Disk Encryption [x]
    - Supported Standard and Premium
    - Must encrypt OS partition first
    - Only support Azure Key Management service
---
- Typical case : Azure Notification Hubs
    - 1 namespaces
    - 2 hubs
    - 1 policies
---
- az moitor metrics alert creat -n A1 -g RG1 --condition "avg Percentage CPU > 95" --windows-size 10m --action AG1 [x]
---
- New-NetFirewallRule -DisplayName "Ping" -Protocol ICMPv4
---
- Monitoring AKS
    - Enable monitoring for the cluster
    - Create a Log Analytics workspace
    - Add Azure Monitor for Containers to the workspace
    - View charts on the Insights page of the AKS cluster
---
- Password Hash Synchronization, Pass-through Authentication supported SSO scenario
---

- Backup and Recovery Vault
    - Backup Scenario
        1. Create Vault
        1. Create Backup Policy
        1. Select VM -> Enable backup
    - Site Recovery from On-Premise Hyper-V
        1. Create Recovery Services vault
        1. Set Protection goal to migration from on-premise to Azure
        1. Create Hyper-V site and add to VM
        1. Install Site Recovery Agent on local VM
        1. Register Hyper-V site in vault
    - From AWS to Azure
        1. Create Vault
        1. Create Storage Account
        1. Prepare a Vault
---
- az provider register --namespace Microsoft.EventGrid
--
- Cosmos DB => Eventual
---
- Monitoring AKS
    - From Azure Portal Enable Monitor for Cluster
    - Create Log Analytics
    - Add AKS into workspace
    - View chart from Insights Page

---
- ../api/logstream to track progress for Windows Container Apps
---

