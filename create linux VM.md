# Create Linux VM

__Create cloud-init.txt__
```yaml
    #cloud-config
    package_upgrade: true
    packages:
    - nginx
    - nodejs
    - npm
    write_files:
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
    az group create --name myLinux01 --location southeastasia
```

__Create Linux VM__
```bash
az vm create \
    --resource-group myLinux0101 \
    --name myLinux01 \
    --image UbuntuLTS \
    --admin-username azureuser \
    --generate-ssh-keys \
    --custom-data cloud-init.txt
```

__Get IP Address__

```bash
    az vm list-ip-addresses --resource-group myLinux01 --name myLinux01 -o table
```

__Setup NSG__
- List NSG
```bash
    az network nsg list --resource-group myLinux01 -o table
```

- List and Create NSG Rules
```bash
    az network nsg rule list --nsg-name myLinux01NSG --resource-group myLinux01

    az network nsg rule create -g myLinux01 --nsg-name myLinux01NSG -n nodeweb --priority 100 --destination-port-ranges 3000
```

__Connect to VM by SSH__

```bash
    ssh azureuser@ip
```

__Clean resources__
```bash
    az group delete --name myLinux01 \
    --no-wait --yes
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

