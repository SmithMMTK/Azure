## Index
- [COMPUTE](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#compute)
- [STORAGE](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#storage)
- [NETWORKING](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#networking)
- [SECURITY](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#security)

---
### COMPUTE 

---
### STORAGE
#### [Azure Storage Service](https://docs.microsoft.com/en-us/azure/storage/common/storage-introduction)

- Hot - Optimized for storing data that is accessed frequently.
- Cool - Optimized for storing data that is infrequently accessed and stored for at least **30 days**.
- Archive - Optimized for storing data that is rarely accessed and stored for at least **180 days** with flexible latency requirements (on the order of hours).

    You may only tier your object storage data to hot, cool, or archive in Blob storage and General Purpose v2 (GPv2) accounts

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

#### [Access Review - Overview](https://docs.microsoft.com/en-us/azure/active-directory/governance/access-reviews-overview)
    
Azure Active Directory (Azure AD) access reviews enable organizations to efficiently manage group memberships, access to enterprise applications, and role assignments. User's access can be reviewed on a regular basis to make sure only the right people have continued access [How to: Configure Access Review](https://docs.microsoft.com/en-us/azure/active-directory/governance/create-access-review).   

- Security group members, Office group members
- Assigned to a connected app

You can use Azure Active Directory (Azure AD) Privileged Identity Management (PIM) to create access reviews for privileged Azure AD roles.
- Azure AD role
- Azure resource role
