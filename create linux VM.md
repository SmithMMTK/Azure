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
  - sudo sed -i 's/scripts-user$/\[scripts-user, always\]/' /etc/cloud/cloud.cfg
  - service nginx restart
  - cd "/home/azureuser/myapp"
  - npm init
  - npm install express -y
  - nodejs index.js
```

__Cloud-init Configuration__
- Configuration File
  >/etc/cloud/cloud.cfg
- Debuging File
  >/var/log/cloud-init.log


__Create Resource Group__
```bash
    az group create --name myLinux27 --location southeastasia
```

__Create Linux VM__
```bash
az vm create \
    --resource-group myLinux27 \
    --name myLinux27 \
    --image UbuntuLTS \
    --admin-username azureuser \
    --generate-ssh-keys \
    --custom-data cloud-init.txt
```

__Get IP Address__

```bash
    az vm list-ip-addresses --resource-group myLinux27 --name myLinux27 -o table
```

__Setup NSG__
- List NSG
```bash
    az network nsg list --resource-group myLinux27 -o table
```

- List and Create NSG Rules
```bash
    az network nsg rule list --nsg-name myLinux27NSG --resource-group myLinux27

    az network nsg rule create -g myLinux27 --nsg-name myLinux27NSG -n nodeweb --priority 100 --destination-port-ranges 80
```

__Connect to VM by SSH__

```bash
    ssh azureuser@ip
```

__Clean resources__
```bash
    az group delete --name myLinux27 \
    --no-wait --yes
```