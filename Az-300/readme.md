## Index
- [COMPUTE](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#compute)
    - [Container](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#container)
- [APPLICATION](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#application)
- [STORAGE](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#storage)
    - [Storage Service](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#azure-storage-service)
- [NETWORKING](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#networking)
    - [Load Balancer](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#load-balancer---overview)
- [SECURITY](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#security)
    - [Access Review](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#access-review---overview)
    - [Key Vault](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#key-vault)
- [AUTOMATION](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#automation)

---
### COMPUTE 
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

**[How-to: Create and deploy container image](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-tutorial-prepare-app)**

**Azure Web App for Continers** 

```bash
    az webapp config container set // Change container image
    az webapp deployment container // Enable CD
    az webapp deploymnet source // Enable Git
```



---
### APPLICATION


---
### STORAGE
#### [Azure Storage Service](https://docs.microsoft.com/en-us/azure/storage/common/storage-introduction)

- Hot - Optimized for storing data that is accessed frequently.
- Cool - Optimized for storing data that is infrequently accessed and stored for at least **30 days**.
- Archive - Optimized for storing data that is rarely accessed and stored for at least **180 days** with flexible latency requirements (on the order of hours).
    **Only support at Blob level.**

    **Blob-level tiering billing**

    | Operation|Write Charges (Operation + Access) | Read Charges (Operation + Access) |
    |----|---|---|
    | SetBlobTier Direction | hot->cool, hot->archive, cool->archive | archive->cool, archive->hot, cool->hot |

---

### NETWORKING
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

```bash
      az network lb create \
      --resource-group myResourceGroupSLB \
      --name myLoadBalancer \
      --sku standard \
      --public-ip-address myPublicIP \
      --frontend-ip-name myFrontEnd \
      --backend-pool-name myBackEndPool
```
---

### SECURITY

#### [Azure AD Device Identity](https://docs.microsoft.com/en-us/azure/active-directory/devices/)

Through devices in Azure AD, your users are getting access to your corporate assets. To protect your corporate assets, as an IT administrator, you want to manage these device identities in Azure AD. This enables you to make sure that your users are accessing your resources from devices that meet your standards for security and compliance.



#### [Access Review - Overview](https://docs.microsoft.com/en-us/azure/active-directory/governance/access-reviews-overview)
    
Azure Active Directory (Azure AD) **Access Reviews** enable organizations to efficiently manage group memberships, access to enterprise applications, and role assignments. User's access can be reviewed on a regular basis to make sure only the right people have continued access [How to: Configure Access Review](https://docs.microsoft.com/en-us/azure/active-directory/governance/create-access-review).   

- Security group members, Office group members
- Assigned to a connected app

You can use Azure Active Directory (Azure AD) Privileged Identity Management (**PIM**) to create access reviews for privileged Azure AD roles.
- Azure AD role
- Azure resource role

#### [Key Vault](https://docs.microsoft.com/en-in/azure/key-vault/key-vault-overview)

- Secrets Management - Azure Key Vault can be used to Securely store and tightly control access to **tokens, passwords, certificates, API keys, and other secrets**

- Key Management - Azure Key Vault can also be used as a Key Management solution. Azure Key Vault makes it easy to create and control the **encryption keys used to encrypt your data**.

- Certificate Management - Azure Key Vault is also a service that lets you easily provision, manage, and deploy public and private Secure Sockets Layer/Transport Layer Security (SSL/TLS) certificates for use with Azure and your internal connected resources.

- Store secrets backed by Hardware Security Modules - The secrets and keys can be protected either by software or FIPS 140-2 Level 2 validates HSMs

    [How-to: Create Secret by Power Shell](https://docs.microsoft.com/en-in/azure/key-vault/quick-create-powershell)

```powershell
    New-AzKeyVault -Name 'my-Vault' -ResourceGroupName 'myResourceGroup' -Location 'East US'

    $secretvalue = ConvertTo-SecureString 'hVFkk965BuUv' -AsPlainText -Force

    $secret = Set-AzKeyVaultSecret -VaultName 'my-Vault' -Name 'ExamplePassword' -SecretValue $secretvalue

    (Get-AzKeyVaultSecret -vaultName "my-Vault" -name "ExamplePassword").SecretValueText
```


### AUTOMATION
- Resource Group and ARM Template Deployment
    ```powershell
        $resourceGroupName = Read-Host -Prompt "Enter the Resource Group name"
        $location = Read-Host -Prompt "Enter the location (i.e. centralus)"
        
        New-AzResourceGroup -Name $resourceGroupName -Location $location
        New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName `
        -TemplateUri https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-storage-account-create/azuredeploy.json
    ```

    Two differrence parameters:
    - New-AzResourceGroup **-Name**
    - New-AzResourceGroupDeployment **-ResourceGroupName**
    
