# Create Windows VM



```bash
vmname=az300winvm$RANDOM
az group create --name $vmname --location southeastasia

az vm create \
    --resource-group $vmname \
    --name $vmname \
    --image win2016datacenter \
    --admin-username azureuser \
    --admin-password pass@word1w$vmname
    
echo pass@word1w$vmname

az vm open-port --port 80 \
--resource-group $vmname --name $vmname

```

Install IIS 
```powershell
Install-WindowsFeature -name Web-Server -IncludeManagementTools
```

```bash
az group delete --name $vmname --no-wait -y
```