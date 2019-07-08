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
    az group create --name myLinux2 --location southeastasia
```

__Create Linux VM__
```bash
az vm create \
    --resource-group myLinux2 \
    --name myLinux2 \
    --image UbuntuLTS \
    --admin-username azureuser \
    --generate-ssh-keys \
    --custom-data cloud-init.txt
```

__Get IP Address__

```bash
    az vm list-ip-addresses --resource-group myLinux2 --name myLinux2 -o table
```

__Setup NSG__
- List NSG
```bash
    az network nsg list --resource-group myLinux2 -o table
```

- List and Create NSG Rules
```bash
    az network nsg rule list --nsg-name myLinux2NSG --resource-group myLinux2

    az network nsg rule create -g myLinux2 --nsg-name myLinux2NSG -n nodeweb --priority 100 --destination-port-ranges 80
```

__Connect to VM by SSH__

```bash
    ssh azureuser@ip
```

__Clean resources__
```bash
    az group delete --name myLinux2 \
    --no-wait --yes
```