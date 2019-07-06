# VM Scale Set Hands-On Experience

## Create VM Scale Set ([detail](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/tutorial-create-and-manage-cli))

__Create Resource Group__
```bash
    az group create --name myResourceGroup --location southeastasia
```

__Create a Scale Set__
```bash
    az vmss create \
    --resource-group myResourceGroup \
    --name myScaleSet \
    --image UbuntuLTS \
    --admin-username azureuser \
    --generate-ssh-keys
```

__View the VM instances in a scale set__
```bash
    az vmss list-instances \
    --resource-group myResourceGroup \
    --name myScaleSet \
    --output table
```
>To view additional information about a specific VM instance, add the --instance-id parameter to az vmss get-instance-view. 
```bash
    az vmss get-instance-view \
    --resource-group myResourceGroup \
    --name myScaleSet \
    --instance-id 1
```

__List connection information__
```bash
    az vmss list-instance-connection-info \
    --resource-group myResourceGroup \
    --name myScaleSet
```