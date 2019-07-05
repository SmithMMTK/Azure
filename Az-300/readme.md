## Index
- [COMPUTE](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#compute)
    - [Auto-Scale](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#auto-scale)
- [APPLICATION](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#application)
    - [Container](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#container)
    - [Azure messaging services](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#azure-messaging-services)
- [STORAGE](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#storage)
    - [Storage Service](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#azure-storage-service)
    - [Cosmos DB](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#cosmos-db)
- [NETWORKING](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#networking)
    - [Application Gateway](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#application-gateway)
    - [Load Balancer](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#load-balancer---overview)
    - [Networking Options](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#networking-options)
- [SECURITY](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#security)
    - [Managed Identities for Azure Resources](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#managed-identities-for-azure-resources)
    - [Azure AD Device Identity](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#azure-ad-device-identity)
    - [Access Review](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#access-review---overview)
    - [Key Vault](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#key-vault)
    - [Role-based access control (RBAC)](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#role-based-access-control-rbac)
- [AUTOMATION](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#automation)



---
### COMPUTE 


#### [Auto Scale](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/autoscale-best-practices)

**Before Scaling down**, autoscale tries to estimate what the final state will be if it scaled in example:
>- Current Instance = 3
>- Default = 2
>- Scale-up when Avg CPU > 80
>- Scale-down when Avg CPU < 60
>- Average load reduce to 75, (75x3) / 2 = 112.5 => No Scale-down
>- Averge load reduce to 50, (50x3) / 2 = 75 => Scale-down by 1

**Auto Scale Rule**
>- Time aggregation: Maximum
>- Metric name: CPU Percentage
>- Time grain statistic: Average
>- Operator: Greater than
>- Threshold: 80
>- Duration (in minutes): 10
>- Actions: Increase count to
>    - Increase count by: // for add additional instance
>- Instance count: 3


---
### APPLICATION

#### [Container](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-overview)

**Build the container image**

Windows environment
```docker
    FROM windows/iis
    RUN mkdir -p c:\app
    COPY app c:\app
    WORKDIR c:\app
    RUN npm install
    CMD node index.js
```


Linux environment
    
    git clone https://github.com/Azure-Samples/aci-helloworld.git

```docker
    FROM node:8.9.3-alpine
    RUN mkdir -p /Users/smithm/app
    COPY ./app/* /Users/smithm/app/
    WORKDIR /Users/smithm/app
    RUN npm install
    CMD node /Users/smithm/app/index.js
```

Set a command or process that will run each time a container is run **CMD** 

    docker build ./aci-helloworld -t aci-tutorial-app

**Hands-On [Create and deploy container image](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-tutorial-prepare-app)**

**Azure Web App for Continers** 

```bash
    az webapp config container set // Change container image
    az webapp deployment container // Enable CD
    az webapp deploymnet source // Enable Git
```

**Web Jobs** is a feature of Azure App Service that enables you to run a program or script in the same context as a web app, API app, or mobile app. There is no additional cost to use WebJobs ([detail](https://docs.microsoft.com/en-us/azure/app-service/webjobs-create)).


#### [Azure messaging services](https://docs.microsoft.com/en-us/azure/event-grid/compare-messaging-services)

Azure offers three services that assist with delivering event messages throughout a solution. These services are:

- [Event Grid](https://docs.microsoft.com/en-us/azure/event-grid/)
- [Event Hubs](https://docs.microsoft.com/en-us/azure/event-hubs/)
- [Service Bus](https://docs.microsoft.com/en-us/azure/service-bus-messaging/)

**Comparison of services**

| **Service** | **Purpose** | **Type** | **When to use** |
|---|---|---|---|
| Event Grid | Reactive programming | Event distribution (discrete) | React to status changes |
| Event Hubs | Big data pipeline | Event streaming (series) | Telemetry and distributed data streaming |
| Service Bus | High-value enterprise messaging | Message | Order processing and financial transactions |


---
### STORAGE
#### [Azure Storage Service](https://docs.microsoft.com/en-us/azure/storage/common/storage-introduction)

- Hot - Optimized for storing data that is accessed frequently.
- Cool - Optimized for storing data that is infrequently accessed and stored for at least **30 days**.
- Archive - Optimized for storing data that is rarely accessed and stored for at least **180 days** with flexible latency requirements (on the order of hours).
    >**Only support at Blob level.**

    **Blob-level tiering billing**

    | Operation | Write Charges (Operation + Access) | Read Charges (Operation + Access) |
    |----|---|---|
    | SetBlobTier Direction | hot->cool, hot->archive, cool->archive | archive->cool, archive->hot, cool->hot |

#### [Cosmos DB](https://docs.microsoft.com/en-us/azure/cosmos-db/introduction)

[Consistency, availability, and performance tradeoffs](https://docs.microsoft.com/en-us/azure/cosmos-db/consistency-levels-tradeoffs)

You can choose from five well-defined models on the consistency spectrum. From strongest to weakest, the models are:

- Strong
- Bounded staleness
- Session
- Consistent prefix
- Eventual

Consistency levels and latency
- The read latency for all consistency levels is always guaranteed to be **less than 10 milliseconds** at the 99th percentile.
    - The average read latency, at the 50th percentile, is typically 2 milliseconds or less
- The write latency for all consistency levels is always guaranteed to be **less than 10 milliseconds** at the 99th percentile.
    - The average write latency, at the 50th percentile, is usually 5 milliseconds or less

[Consistency levels and data durability](https://docs.microsoft.com/en-us/azure/cosmos-db/consistency-levels)
![alt text](https://docs.microsoft.com/en-us/azure/cosmos-db/media/consistency-levels/five-consistency-levels.png)

---

### NETWORKING
#### [Application Gateway](https://docs.microsoft.com/en-us/azure/application-gateway/overview)
With Application Gateway, you can make routing decisions based on additional attributes of an HTTP request, such as URI path or host headers. For example, you can route traffic based on the incoming URL. So if /images is in the incoming URL, you can route traffic to a specific set of servers (known as a pool) configured for images. If /video is in the URL, that traffic is routed to another pool that's optimized for videos.
    
![alt text](https://docs.microsoft.com/en-us/azure/application-gateway/media/application-gateway-url-route-overview/figure1-720.png)

#### [Load Balancer - Overview](https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-overview)

By default, Load Balancer uses a 5-tuple hash composed of source IP address, source port, destination IP address, destination port, and IP protocol number to map flows to available servers. You can choose to create affinity to a specific source IP address by opting into a 2- or 3-tuple hash for a given rule. All packets of the same packet flow arrive on the same instance behind the load-balanced front end. When the client initiates a new flow from the same source IP, the source port changes. As a result, the 5-tuple might cause the traffic to go to a different backend endpoint.

![alt text](https://docs.microsoft.com/en-us/azure/load-balancer/media/load-balancer-overview/load-balancer-distribution.png)

[How to: Create Load Balancer by PowerShell](https://docs.microsoft.com/en-us/azure/load-balancer/quickstart-create-standard-load-balancer-powershell)

If you choose to install and use PowerShell locally, this article requires the Azure PowerShell module version 5.4.1 or later. Run Get-Module -ListAvailable Az to find the installed version.

```powershell
    $nb = New-AzLoadBalancer `
    -ResourceGroupName $rgName `
    -Name 'MyLoadBalancer' `
    -SKU Standard `
    -Location $location `
    -FrontendIpConfiguration $feip `
    -BackendAddressPool $bepool `
    -Probe $probe `
    -LoadBalancingRule $rule `
    -InboundNatRule $natrule1,$natrule2,$natrule3
```

```powershell
    $probe = New-AzLoadBalancerProbeConfig `
    -Name "myHealthProbe" `
    -RequestPath healthcheck2.aspx `
    -Protocol http `
    -Port 80 `
    -IntervalInSeconds 16 `
    -ProbeCount 2
```

```bash
      az network lb create \
      --resource-group myResourceGroupSLB \
      --name myLoadBalancer \
      --sku standard \
      --public-ip-address myPublicIP \
      --frontend-ip-name myFrontEnd \
      --backend-pool-name myBackEndPool
```

ExpressRoute lets you extend your on-premises networks into the Microsoft cloud over a private connection facilitated by a connectivity provider

#### [Networking Options](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview)

- [Hub-spoke topology](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke) The hub is a virtual network (VNet) in Azure that acts as a central point of connectivity to your on-premises network. The spokes are VNets that peer with the hub, and can be used to isolate workloads. 

![Alt Text](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/images/hub-spoke.png)

- [Express Route](https://docs.microsoft.com/en-us/azure/expressroute/expressroute-about-virtual-network-gateways)
ExpressRoute lets you extend your on-premises networks into the Microsoft cloud over a private connection facilitated by a connectivity provider

- [VNet Peering](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-peering-overview) Virtual network peering enables you to seamlessly connect Azure virtual networks. Once peered, the virtual networks appear as one, for connectivity purposes. The traffic between virtual machines in the peered virtual networks is routed through the Microsoft backbone infrastructure, much like traffic is routed between virtual machines in the same virtual network, through private IP addresses only. Azure supports:

    - VNet peering - connecting VNets within the same Azure region
    - Global VNet peering - connecting VNets across Azure regions

- [VPN Gateway](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways) A VPN gateway is a specific type of virtual network gateway that is used to send encrypted traffic between an Azure virtual network and an on-premises location over the public Internet.
    - [Point-to-Site VPN](https://docs.microsoft.com/en-us/azure/vpn-gateway/point-to-site-about)
    - [Site-to-Site VPN](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpn-devices)


---

### SECURITY

#### [Managed identities for Azure resources](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview)

The feature provides Azure services with an automatically managed identity in Azure AD. You can use the identity to authenticate to any service that supports Azure AD authentication, including Key Vault, without any credentials in your code.

- Hands-on: [Windows VM with Managed Identities](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/tutorial-windows-vm-access-arm)
- Hands-on: [Linux VM with Managed Identities](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/tutorial-linux-vm-access-arm)
- Hadns-on: [Windows VM Access Storage Account via SAS](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/tutorial-windows-vm-access-storage-sas)

Quick-Steps ([detail:](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/tutorial-windows-vm-access-arm))
- Add role assignment (**Reader**) to **all resource groups**
- Use **Invoke** cmdlet to get access token
    ```powershell
    $response = Invoke-WebRequest -Uri 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://management.azure.com/' 
    -Method GET -Headers @{Metadata="true"}

    $content = $response.Content | ConvertFrom-Json

    $ArmToken = $content.access_token
    ```
- Call Azure Resource Manager using access token
    ```powershell
    (Invoke-WebRequest -Uri https://management.azure.com/subscriptions/<SUBSCRIPTION ID>/resourceGroups/<RESOURCE GROUP>?api-version=2016-06-01 
    -Method GET -ContentType "application/json" 
    -Headers @{ Authorization ="Bearer $ArmToken"}).content
    ```

#### [Azure AD Device Identity](https://docs.microsoft.com/en-us/azure/active-directory/devices/)

Through devices in Azure AD, your users are getting access to your corporate assets. To protect your corporate assets, as an IT administrator, you want to manage these device identities in Azure AD. This enables you to make sure that your users are accessing your resources from devices that meet your standards for security and compliance.

__Device Identity__ ([detail](https://docs.microsoft.com/en-us/azure/active-directory/devices/overview))
- [Azure AD registered (Win10, iOS, Android, MacOS)](https://docs.microsoft.com/en-us/azure/active-directory/devices/concept-azure-ad-register)

- [Azure AD Joined (Win10)](https://docs.microsoft.com/en-us/azure/active-directory/devices/concept-azure-ad-join)
    - [Plan AD Joined implementation](https://docs.microsoft.com/en-us/azure/active-directory/devices/azureadjoin-plan)
        - Managed environment - A managed environment can be deployed either through Password Hash Sync or Pass Through Authentication with Seamless Single Sign On.
        
            These scenarios don't require you to configure a federation server for authentication.

        - Federated environment - A federated environment should have an identity provider that supports both WS-Trust and WS-Fed protocols:
            - **WS-Fed**: This protocol is required to join a device to Azure AD.
            - **WS-Trust**: This protocol is required to sign in to an Azure AD joined device.

- [Hybrid Azure AD Joined (Win7, Win8.1, Win10, WinSvr2008+)](https://docs.microsoft.com/en-us/azure/active-directory/devices/concept-azure-ad-join-hybrid)




#### [Access Review - Overview](https://docs.microsoft.com/en-us/azure/active-directory/governance/access-reviews-overview)
    
Azure Active Directory (Azure AD) **Access Reviews** enable organizations to efficiently manage group memberships, access to enterprise applications, and role assignments. User's access can be reviewed on a regular basis to make sure only the right people have continued access [How to: Configure Access Review](https://docs.microsoft.com/en-us/azure/active-directory/governance/create-access-review).   

- Security group members, Office group members
- Assigned to a connected app

You can use Azure Active Directory (Azure AD) Privileged Identity Management (**PIM**) to create access reviews for privileged Azure AD roles.
- Azure AD role
- Azure resource role

#### [Key Vault](https://docs.microsoft.com/en-in/azure/key-vault/key-vault-overview)

Azure Key Vault helps solve the following problems:

- Secrets Management - Azure Key Vault can be used to Securely store and tightly control access to __tokens, passwords, certificates, API keys, and other secrets__
- Key Management - Azure Key Vault can also be used as a Key Management solution. Azure Key Vault makes it easy to create and control the __encryption keys used to encrypt your data.__
- Certificate Management - Azure Key Vault is also a service that lets you easily provision, manage, and deploy public and private Secure Sockets Layer/Transport Layer Security (SSL/TLS) certificates for use with Azure and your internal connected resources.
- Store secrets backed by Hardware Security Modules - The secrets and keys can be protected either by software or FIPS 140-2 Level 2 validates HSMs

[How-to: Create Secret by Power Shell](https://docs.microsoft.com/en-in/azure/key-vault/quick-create-powershell)

```powershell
    New-AzKeyVault -Name 'my-Vault' -ResourceGroupName 'myResourceGroup' -Location 'East US'

    $secretvalue = ConvertTo-SecureString 'hVFkk965BuUv' -AsPlainText -Force

    $secret = Set-AzKeyVaultSecret -VaultName 'my-Vault' -Name 'ExamplePassword' -SecretValue $secretvalue

    (Get-AzKeyVaultSecret -vaultName "my-Vault" -name "ExamplePassword").SecretValueText
```

__Use Azure Key Vault with an Azure web app in .NET__ ([detail](https://docs.microsoft.com/en-us/azure/key-vault/tutorial-net-create-vault-azure-web-app))

```c#
    async Task<string>GetConnectionString(string secretUri)
    {
        var provider = new AzureServiceTokenProvider();
        var callback = new KeyVaultClient.AuthenticationCallback(provider.KeyVaultTokenCallBack);
        var client = new KeyVaultClient(callback);
        var secreat = await client.GetSecret(secretUri);
        return secreat.Value;
    }
```

__Key generation plan__ ([detail](https://docs.microsoft.com/en-us/azure/storage/common/storage-security-guide#key-regeneration-plan))

1. Regenerate Key 2 to ensure that it is secure. You can do this in the Azure portal.
1. In all of the applications where the storage key is stored, change the storage key to use Key 2's new value. Test and publish the application.
1. After all of the applications and services are up and running successfully, regenerate Key 1. This ensures that anybody to whom you have not expressly given the new key will no longer have access to the storage account



#### [Role-based access control (RBAC)](https://docs.microsoft.com/en-us/azure/role-based-access-control/overview)
Access management for cloud resources is a critical function for any organization that is using the cloud. Role-based access control (RBAC) helps you manage who has access to Azure resources, what they can do with those resources, and what areas they have access to.

![Alt text](https://docs.microsoft.com/en-us/azure/role-based-access-control/media/overview/rbac-least-privilege.png)

__How RBAC works__ ([detail](https://docs.microsoft.com/en-us/azure/role-based-access-control/overview#how-rbac-works))

- Security principal : A security principal is an object that represents a user, group, service principal, or managed identity that is requesting access to Azure resources.

    ![Alt text](https://docs.microsoft.com/en-us/azure/role-based-access-control/media/overview/rbac-security-principal.png)

- Role definition : A role definition is a collection of permissions. It's sometimes just called a role. A role definition lists the operations that can be performed, such as read, write, and delete. Roles can be high-level, like owner, or specific, like virtual machine reader

    ![Alt text](https://docs.microsoft.com/en-us/azure/role-based-access-control/media/overview/rbac-role-definition.png)

- Scope : Scope is the set of resources that the access applies to. When you assign a role, you can further limit the actions allowed by defining a scope. 

    ![Alt text](https://docs.microsoft.com/en-us/azure/role-based-access-control/media/overview/rbac-scope.png)

- Role assignments : A role assignment is the process of attaching a role definition to a user, group, service principal, or managed identity at a particular scope for the purpose of granting access. Access is granted by creating a role assignment, and access is revoked by removing a role assignment

    ![Alt text](https://docs.microsoft.com/en-us/azure/role-based-access-control/media/overview/rbac-overview.png)


```bash
    az role definition create --role-definition customrole.json
    
    az role assignment create --role "App Svc Contributor" 
        --assignee-object-id "GUID"
        --assignee "user/group"
```

```json
    {
        "Actions" : [ ],
        "NotActions" : [ ],
        "DataActions" : [ 
            "Microsoft.Storage/storageAccounts/blobServices/containers/delete",
            "Microsoft.Storage/storageAccounts/blobServices/containers/read",
            "Microsoft.Storage/storageAccounts/blobServices/containers/write"],
        "NoDataActions" : [ "Exclusion" ]
    }

```

__Understand role definitions for Azure resources__ ([Detail](https://docs.microsoft.com/en-us/azure/role-based-access-control/role-definitions))






---

### AUTOMATION
- Resource Group and ARM Template Deployment
    ```powershell
        $resourceGroupName = Read-Host -Prompt "Enter the Resource Group name"
        $location = Read-Host -Prompt "Enter the location (i.e. centralus)"
        
        New-AzResourceGroup -Name $resourceGroupName -Location $location
        New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName `
        -TemplateUri https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-storage-account-create/azuredeploy.json
    ```

    >Two differrence parameters:
    >- New-AzResourceGroup **-Name**
    >- New-AzResourceGroupDeployment **-ResourceGroupName**
    
- Invoke SQL Command
    ```powershell
        Invoke-Sqlcmd -Query "SELECT GETDATE() AS TimeOfQuery"
        -ServerInstance "MyComputer\MainInstance"
    ```

- Migrate from AWS to Azure ([detail](https://docs.microsoft.com/en-us/azure/site-recovery/migrate-tutorial-aws-azure))
    >- Prepare Infrastructure
    >    1. Create Storage Account
    >    1. Create Vault
    >    1. Create Virtual Network

- Sets properties for a database, or moves an existing database into an elastic pool ([detail](https://docs.microsoft.com/en-us/powershell/module/azurerm.sql/set-azurermsqldatabase?view=azurermps-6.13.0))
    ```powershell
        Set-AzureRmSqlDatabase -ResourceGroupName "ResourceGroup01"
        -DatabaseName "Database01" -ServerName "Server01"
        -Edition "Standard" -RequestedServiceObjectiveName "S2"

        Set-AzureRmSqlDatabase -ResourceGroupName "ResourceGroup01"
        -DatabaseName "Database01" -ServerName "Server01" 
        -ElasticPoolName "ElasticPool01"
    ```
- Azure Resource Manager templates ([detail](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-authoring-templates))

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
    - parameters : Values that are provided when deployment is executed to customize resource deployment.
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
    - variables : Values that are used as JSON fragments in the template to simplify template language expressions.
    - resources : Resource types that are deployed or updated in a resource group or subscription.

- __Azure Resource Manager template export__ ([detail](https://azure.microsoft.com/en-us/blog/export-template/))
    - The __Export-AzureRmResourceGroup__ cmdlet captures the specified resource group as a template and saves it to a JSON file.This can be useful in scenarios where you have already created some resources in your resource group, and then want to leverage the benefits of using template backed deployments
        ```powershell
            Export-AzureRmResourceGroup -ResourceGroupName "TestGroup" 
        ```
        
        >__Export__ _cmdlet is capture change and save templete to a JSON file._

    - The __Save-AzureRmResourceGroupDeploymentTemplate__ cmdlet saves a resource group deployment template to a JSON file.





