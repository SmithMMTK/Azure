## Index
- [COMPUTE](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#compute)
- [NETWORKING](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#networking)
- [SECURITY](https://github.com/SmithMMTK/home/blob/master/Az-300/readme.md#security)

---
### COMPUTE
---

### NETWORKING
#### [Load Balancer - Overview](https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-overview)

By default, Load Balancer uses a 5-tuple hash composed of source IP address, source port, destination IP address, destination port, and IP protocol number to map flows to available servers. You can choose to create affinity to a specific source IP address by opting into a 2- or 3-tuple hash for a given rule. All packets of the same packet flow arrive on the same instance behind the load-balanced front end. When the client initiates a new flow from the same source IP, the source port changes. As a result, the 5-tuple might cause the traffic to go to a different backend endpoint.


![alt text](https://docs.microsoft.com/en-us/azure/load-balancer/media/load-balancer-overview/load-balancer-distribution.png)
  

- [Create LB by PowerShell](https://docs.microsoft.com/en-us/azure/load-balancer/quickstart-create-standard-load-balancer-powershell)

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

### [Access Review - Overview](https://docs.microsoft.com/en-us/azure/active-directory/governance/access-reviews-overview)
  - [Access Review - How To](https://docs.microsoft.com/en-us/azure/active-directory/governance/create-access-review)
