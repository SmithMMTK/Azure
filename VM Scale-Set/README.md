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


