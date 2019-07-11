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

[__x__] KQL Hearbeat
    ```KQL
    Heartbeat
    | where TimeGenerated > ago(7d)
    | summarize max(TimeGenerated) by Computer
    | where max_TimeGenerated < ago(1d)
    ```

---

[__x__] Backup all from VMs
    - Create a Recovery Services vault
    - Define a backup policy to protect the VMs
    - Perform the initial backup

[__x__] az role assignment create --role "App Contributor" assignee-object-id "GUID"

