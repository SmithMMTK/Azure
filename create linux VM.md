# Create Linux VM

__Create Resource Group__
```bash
az group create --name myLinux --location southeastasia
```

__Create Linux VM__
```bash
az vm create \
    --resource-group myLinux \
    --name myLinux \
    --image UbuntuLTS \
    --admin-username azureuser \
    --generate-ssh-keys
```

__Get IP Address__

```bash
    az vm list-ip-addresses --resource-group myLinux --name myLinux -o table
```

__Setup NSG__
- List NSG
```bash
    az network nsg list --resource-group myLinux -o table
```

- List and Create NSG Rules
```bash
    az network nsg rule list --nsg-name myLinuxNSG --resource-group myLinux

    az network nsg rule create -g myLinux --nsg-name myLinuxNSG -n nodeweb --priority 100 --destination-port-ranges 3000
```

__Connect to VM by SSH__

```bash
    ssh azureuser@ip
```

__Create installation script__

```bash
    sudo apt-get update --yes
    sudo apt-get install nodejs --yes
    sudo apt-get install npm --yes
    rm -rf nodejs_express    
    git clone https://github.com/SmithMMTK/nodejs-express
    cd nodejs-express
    npm install --yes
    nodejs app.js

```

