# Create Linux VM

__[Create Automation when first boot](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/tutorial-automate-vm-deployment)__


__Download__ [cloud-init.txt](https://github.com/SmithMMTK/home/blob/master/VM%20Scale-Set/cloud-init.txt)

__Cloud-init Configuration__
- Configuration File
  >/etc/cloud/cloud.cfg
- Debuging File
  >/var/log/cloud-init.log


__Create Resource Group__
```bash
    vmname=az300linuxvm$RANDOM
    az group create --name $vmname --location southeastasia
```

__Create Linux VM__
```bash
az vm create \
    --resource-group $vmname \
    --name $vmname \
    --image UbuntuLTS \
    --admin-username azureuser \
    --generate-ssh-keys \
    --custom-data cloud-init.txt
```

__Get IP Address__

```bash
    az vm list-ip-addresses --resource-group $vmname --name $vmname -o table
```

__Setup NSG__
- List NSG
```bash
    az network nsg list --resource-group $vmname -o table
```

- List and Create NSG Rules
```bash
    az network nsg rule list --nsg-name $vmnameNSG --resource-group $vmname

    az network nsg rule create -g $vmname --nsg-name $vmnameNSG -n nodeweb --priority 100 --destination-port-ranges 80
```

__Connect to VM by SSH__

```bash
    ssh azureuser@ip
```

__Clean resources__
```bash
    az group delete --name $vmname \
    --no-wait --yes
```