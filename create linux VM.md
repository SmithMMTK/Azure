# Create Linux VM

__Create Resource Group__
az group create --name myLinux --location southeastasia

__Create Linux VM__
 az vm create \
    --resource-group myLinux \
    --name myLinux \
    --image UbuntuLTS \
    --admin-username azureuser \
    --generate-ssh-keys

