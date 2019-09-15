
##Highly Available VPN 


[Reference - Create a Site-to-Site connection in the Azure portal](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-howto-site-to-site-resource-manager-cli)

__Example values__

    VnetName                = TestVNet1 
    ResourceGroup           = TestRG1 
    Location                = eastus 
    AddressSpace            = 10.11.0.0/16 
    SubnetName              = Subnet1 
    Subnet                  = 10.11.0.0/24 
    GatewaySubnet           = 10.11.255.0/27 
    LocalNetworkGatewayName = Site2 
    LNG Public IP           = <VPN device IP address>
    LocalAddrPrefix1        = 10.0.0.0/24
    LocalAddrPrefix2        = 20.0.0.0/24   
    GatewayName             = VNet1GW 
    PublicIP                = VNet1GWIP 
    VPNType                 = RouteBased 
    GatewayType             = Vpn 
    ConnectionName          = VNet1toSite2

__Set Environment Variable__
```bash
export VnetName="TestVNet1"
export Location="southeastasia"
export ResourceGroup="TestRG1"
export AddressPrefix="10.11.0.0/16"
export Subnet="Subnet1"
export SubnetPrefix="10.11.0.0/24"

```

![alt](https://docs.microsoft.com/en-us/azure/vpn-gateway/media/vpn-gateway-howto-site-to-site-resource-manager-portal/site-to-site-diagram.png)


__Create a virtual network__

```bash
az group create --name $ResourceGroup --location $Location
az network vnet create --name $VnetName --resource-group $ResourceGroup --address-prefix $AddressPrefix --location $Location --subnet-name $Subnet --subnet-prefix $SubnetPrefix

```


__Create__


---

[Reference  - Configure active-active S2S VPN connections with Azure VPN Gateways
](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-activeactive-rm-powershell#aav2v)

Prepare Environment
![alt](https://docs.microsoft.com/en-us/azure/vpn-gateway/media/vpn-gateway-activeactive-rm-powershell/active-active-gw.png)


https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-howto-site-to-site-resource-manager-portal
