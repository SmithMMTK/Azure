# VM Scale Set : Hands-On Experience

## Index
- [Create VM Scale Set](https://github.com/SmithMMTK/home/tree/master/VM%20Scale-Set#create-vm-scale-set-detail)




---

## Create VM Scale Set ([detail](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/tutorial-create-and-manage-cli))

__Create Resource Group__
```bash
    myResourceGroup="azVMSS3"
    myScaleSet="azVMSS3"
    
    az group create --name $myResourceGroup --location southeastasia
```

__Create a Scale Set__
```bash
    az vmss create \
    --resource-group $myResourceGroup \
    --name $myScaleSet \
    --image UbuntuLTS \
    --admin-username azureuser \
    --generate-ssh-keys \
#    --vnet-name VMSS \
#    --subnet vmss
```

__View the VM instances in a scale set__
```bash
    az vmss list-instances \
    --resource-group $myResourceGroup \
    --name $myScaleSet \
    --output table
```
>To view additional information about a specific VM instance, add the --instance-id parameter to az vmss get-instance-view. 
```bash
    az vmss get-instance-view \
    --resource-group $myResourceGroup \
    --name $myScaleSet \
    --instance-id 0
```

__List connection information__
```bash
    az vmss list-instance-connection-info \
    --resource-group $myResourceGroup \
    --name $myScaleSet
```

The following example output shows the instance name, public IP address of the load balancer, and port number that the NAT rules forward traffic to:
```bash
    {
        "instance 1": "13.92.224.66:50001",
        "instance 3": "13.92.224.66:50003"
    }
```

__SSH to your first VM instance. Specify your public IP address and port number with the -p parameter, as shown from the preceding command:__
```bash
    ssh azureuser@13.92.224.66 -p 50001
    lsb_release -a
    exit
```


__Understand VM instance images__
```bash
    az vm image list --output table

    az vm image list --offer CentOS --all --output table
```

__Understand VM instance size__ ([detail](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/tutorial-create-and-manage-cli#vm-instance-sizes))

Type | Common sizes	| Description
--- | --- | ---
General purpose	 | Dsv3, Dv3, DSv2, Dv2, DS, D, Av2, A0-7 | Balanced CPU-to-memory. Ideal for dev / test and small to medium applications and data solutions.
Compute optimized | Fs, F | High CPU-to-memory. Good for medium traffic applications, network appliances, and batch processes.
Memory optimized | Esv3, Ev3, M, GS, G, DSv2, DS, Dv2, D | High memory-to-core. Great for relational databases, medium to large caches, and in-memory analytics.
Storage optimized | Ls | High disk throughput and IO. Ideal for Big Data, SQL, and NoSQL databases.
GPU | NV, NC | Specialized VMs targeted for heavy graphic rendering and video editing.
High performance | H, A8-11 | Our most powerful CPU VMs with optional high-throughput network interfaces (RDMA). 

```bash
    az vm list-sizes --location southeastasia --output table
```

__Change the capacity of a scale set__
- Query existing capacity
```bash
    az vmss show \
    --resource-group $myResourceGroup \
    --name $myScaleSet \
    --query [sku.capacity] \
    --output table
```

- Manually increase or decrease the number of VM instances in the scale set
```bash
    az vmss scale \
    --resource-group $myResourceGroup \
    --name $myScaleSet \
    --new-capacity 0
```

__Start / Stop VM in a Scale Set__

- List VM instances in a scale set
```bash
   az vmss list-instance-connection-info \
     --resource-group $myResourceGroup \
    --name $myScaleSet
```

- Start VM instances in a scale set
```bash
    az vmss start --resource-group $myResourceGroup \
    --name $myScaleSet --instance-ids 1
```

- Stop VM instances in a scale set
```bash
    az vmss stop --resource-group $myResourceGroup \
    --name $myScaleSet --instance-ids 1
```
- Deallocate VM instances in a scale set
```bash
    az vmss deallocate --resource-group $myResourceGroup \
    --name $myScaleSet --instance-ids 1
```

---
## Install applications in virtual machine scale sets with the Azure CLI ([detail](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/tutorial-install-apps-cli))

__What is the Azure Custom Script Extension?__
The Custom Script Extension downloads and executes scripts on Azure VMs. This extension is useful for post deployment configuration, software installation, or any other configuration / management task. Scripts can be downloaded from Azure storage or GitHub, or provided to the Azure portal at extension run-time.

__Extension Custom Script (Linux)__ ([detail](https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-linux))
The extension will only run a script once, if you want to run a script on every boot, then you can use [cloud-init image](https://docs.microsoft.com/azure/virtual-machines/linux/using-cloud-init) and use a [Scripts Per Boot module](https://cloudinit.readthedocs.io/en/latest/topics/modules.html#scripts-per-boot). Alternatively, you can use the script to create a Systemd service unit.


__Create Custom Script Extension definition__
Create file name: ___customConfig.json___
```json
    {
        "fileUris": ["https://raw.githubusercontent.com/Azure-Samples/compute-automation-configurations/master/automate_nginx.sh"],
        "commandToExecute": "./automate_nginx.sh"
    }
```
```json
    {
        "fileUris": ["https://github.com/SmithMMTK/home/blob/master/VM%20Scale-Set/nodesjs.sh"],
        "commandToExecute": "./nodejs.sh"
    }
```

```json
    {
        "commandToExecute": "sudo mkdir test"
    }
```

__Apply the Custom Script Extension__
```bash
    az vmss extension set \
    --publisher Microsoft.Azure.Extensions \
    --version 2.0 \
    --name CustomScript \
    --resource-group $myResourceGroup \
    --vmss-name $myScaleSet \
    --settings @customConfig.json
```

```bash
 az vmss extension set \
    --publisher Microsoft.Azure.Extensions \
    --version 2.0 \
    --name CustomScript \
    --resource-group myResourceGroup \
    --vmss-name myScaleSet \
    --settings @cus2.json
```

```bash
    az vmss extension show \
    --name CustomScript \
    --resource-group $myResourceGroup \
    --vmss-name $myScaleSet
```


__Test your scale set__

__Allow traffic to reach the web server__
To allow traffic to reach the web server, create a load balancer rule with az network lb rule create. The following example creates a rule named myLoadBalancerRuleWeb:

```bash
    az network lb rule create \
    --resource-group myResourceGroup \
    --name myLoadBalancerRuleWeb \
    --lb-name myScaleSetLB \
    --backend-pool-name myScaleSetLBBEPool \
    --backend-port 3000 \
    --frontend-ip-name loadBalancerFrontEnd \
    --frontend-port 80 \
    --protocol tcp

```

To see your web server in action, obtain the public IP address of your load balancer with az network public-ip show. The following example obtains the IP address for myScaleSetLBPublicIP created as part of the scale set:

```bash
    az network public-ip show \
    --resource-group myResourceGroup \
    --name myScaleSetLBPublicIP \
    --query [ipAddress] \
    --output tsv
```


__Experimental : Create customConfig.json for nodejs with express__
> To-do ...

--- 
## Deploy Application and Code by _cloud-init.txt_

###__Deploy Applications and Code__ ([detail](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/tutorial-create-vmss))


__Download__ [cloud-init.txt](https://github.com/SmithMMTK/home/blob/master/VM%20Scale-Set/cloud-init.txt)

- Configuration File
    > /etc/cloud/cloud.cfg
- Debuging File
    > /var/log/cloud-init.log
- Boot Time Analysis - cloud-init analyze
    > cloud-init analyze show -i my-cloud-init.log



### Start Deployment

__Creat Resource Group__
```bash
    az group create --name myResourceGroupScaleSet1 --location southeastasia
```

__Create VM Scale Set with Cloud-init.txt__
```bash
    az vmss create \
    --resource-group myResourceGroupScaleSet1 \
    --name myScaleSet \
    --image UbuntuLTS \
    --upgrade-policy-mode automatic \
    --custom-data cloud-init.txt \
    --admin-username azureuser \
    --generate-ssh-keys
```

__Get Instance SSH IP__
```bash
    az vmss list-instance-connection-info \
        --resource-group myResourceGroupScaleSet1 \
        --name myScaleSet
```

__Create Probe__

```bash
    az network lb probe create --resource-group myResourceGroupScaleSet1 \
    --lb-name myScaleSetLB \
    -n MyProbe --protocol http --port 3000 --path /
```

__Create Load Balancer Rule__

```bash
    az network lb rule create \
    --resource-group myResourceGroupScaleSet1 \
    --name myLoadBalancerRuleWeb \
    --lb-name myScaleSetLB \
    --backend-pool-name myScaleSetLBBEPool \
    --backend-port 3000 \
    --frontend-ip-name loadBalancerFrontEnd \
    --frontend-port 80 \
    --protocol tcp \
    --probe-name MyProbe
```


__Loop Test Client__
```bash
    for (( ; ; ))
    do
        curl http://23.97.60.255
        echo
    done
```

__Clean resources__
```bash
    az group delete --name myResourceGroupScaleSet1 \
    --no-wait --yes
```

## Still pending to work on reboot scenario to keep Nodejs app running

az vmss stop --resource-group myResourceGroupScaleSet1 \
    --name myScaleSet --instance-ids 1


