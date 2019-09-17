
### Create 2 VNET with VPN GW Connection

```bash

az group create -n azvnet1 -l southeastasia
az group create -n azvnet2 -l southeastasia

az network vnet create -g azvnet1 -n vnet1 --address-prefix 10.1.0.0/16 \
--subnet-name subnet1 --subnet-prefix 10.1.0.0/24

az network vnet create -g azvnet2 -n vnet2 --address-prefix 10.2.0.0/16 \
--subnet-name subnet1 --subnet-prefix 10.2.0.0/24

                            
az vm create \
    --resource-group azvnet1 \
    --name vm1  \
    --image UbuntuLTS \
    --admin-username azureuser \
    --vnet-name vnet1 --subnet subnet1 \
    --generate-ssh-keys 
    
az vm create \
    --resource-group azvnet2 \
    --name vm2  \
    --image UbuntuLTS \
    --admin-username azureuser \
    --vnet-name vnet2 --subnet subnet1 \
    --generate-ssh-keys


az network vnet subnet create --vnet-name vnet1 \
-n GatewaySubnet -g azvnet1 --address-prefix 10.1.1.0/27

az network vnet subnet create --vnet-name vnet2 \
-n GatewaySubnet -g azvnet2 --address-prefix 10.2.1.0/27


az network public-ip create -n vnet1pubip -g azvnet1 --allocation-method Dynamic
az network public-ip create -n vnet2pubip -g azvnet2 --allocation-method Dynamic


az network vnet-gateway create -n vnet1gw -l southeastasia \
--public-ip-address vnet1pubip -g azvnet1 --vnet vnet1 \
--gateway-type Vpn --sku VpnGw1 --vpn-type RouteBased --no-wait


az network vnet-gateway create -n vnet2gw -l southeastasia \
--public-ip-address vnet2pubip -g azvnet2 --vnet vnet2 \
--gateway-type Vpn --sku VpnGw1 --vpn-type RouteBased --no-wait



# Check creating status
az network vnet-gateway list --resource-group azvnet1 -o table
az network vnet-gateway list --resource-group azvnet2 -o table


az network public-ip list --resource-group azvnet1 --output table
az network public-ip list --resource-group azvnet2 --output table

# Creat Local Address

az network local-gateway create --gateway-ip-address 52.163.185.164 --name azvnet2 \
--resource-group azvnet1 --local-address-prefixes 10.2.0.0/16

az network local-gateway create --gateway-ip-address 13.76.130.255 --name azvnet1 \
--resource-group azvnet2 --local-address-prefixes 10.1.0.0/16

# Create Connection
az network vpn-connection create --name VNet1toSite2 --resource-group azvnet1 --vnet-gateway1 vnet1gw \
-l southeastasia --shared-key abc123 --local-gateway2 azvnet2

az network vpn-connection create --name VNet2toSite1 --resource-group azvnet2 --vnet-gateway1 vnet2gw \
-l southeastasia --shared-key abc123 --local-gateway2 azvnet1

# Test Connection
az network vpn-connection show --name VNet1toSite2 --resource-group azvnet1 -o table
az network vpn-connection show --name VNet2toSite1 --resource-group azvnet2 -o table


# Delete resource
az group delete -g azvnet1 --no-wait -y
az group delete -g azvnet2 --no-wait -y

```