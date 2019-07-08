# Create Linux VM

__[Create Automation when first boot](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/tutorial-automate-vm-deployment)__

__Create cloud-init.txt__
```yaml
#cloud-config
package_upgrade: true
packages:
  - nginx
  - nodejs
  - npm
write_files:
  - ownwer: azureuser:azureuser
    path: /var/lib/cloud/scripts/per-boot/start.sh
    content: |
      cd "/home/azureuser/myapp"
      nodejs index.js
  - owner: www-data:www-data
    path: /etc/nginx/sites-available/default
    content: |
      server {
        listen 80;
        location / {
          proxy_pass http://localhost:3000;
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection keep-alive;
          proxy_set_header Host $host;
          proxy_cache_bypass $http_upgrade;
        }
      }
  - owner: azureuser:azureuser
    path: /home/azureuser/myapp/index.js
    content: |
      var express = require('express')
      var app = express()
      var os = require('os');
      app.get('/', function (req, res) {
        res.send('Hello World from host ' + os.hostname() + '!')
      })
      app.listen(3000, function () {
        console.log('Hello world app listening on port 3000!')
      })
runcmd:
  - service nginx restart
  - cd "/home/azureuser/myapp"
  - npm init
  - npm install express -y
  - nodejs index.js
```

__Create Resource Group__
```bash
    az group create --name myLinux25 --location southeastasia
```

__Create Linux VM__
```bash
az vm create \
    --resource-group myLinux25 \
    --name myLinux25 \
    --image UbuntuLTS \
    --admin-username azureuser \
    --generate-ssh-keys \
    --custom-data cloud-init.txt
```

__Get IP Address__

```bash
    az vm list-ip-addresses --resource-group myLinux25 --name myLinux25 -o table
```

__Setup NSG__
- List NSG
```bash
    az network nsg list --resource-group myLinux25 -o table
```

- List and Create NSG Rules
```bash
    az network nsg rule list --nsg-name myLinux25NSG --resource-group myLinux25

    az network nsg rule create -g myLinux25 --nsg-name myLinux25NSG -n nodeweb --priority 100 --destination-port-ranges 80
```

__Connect to VM by SSH__

```bash
    ssh azureuser@ip
```

__Clean resources__
```bash
    az group delete --name myLinux25 \
    --no-wait --yes
```

__Troubleshooting cloud-init__

Once the VM has been provisioned, cloud-init will run through all the modules and script defined in --custom-data in order to configure the VM. If you need to troubleshoot any errors or omissions from the configuration, you need to search for the module name (disk_setup or runcmd for example) in the cloud-init log - located in __/var/log/cloud-init.log__.

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
>
> write_file:
>  - owner: azureuser:azureuser
>    path: /var/lib/cloud/scripts/per-boot/start.js
>    content: |
>      cd "/home/azureuser/myapp"
>      nodejs index.js
