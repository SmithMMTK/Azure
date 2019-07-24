## Create AKS cluster

```bash
aksname=az300aks81w$RANDOM

az group create --name $aksname --location southeastasia

az aks create \
    --resource-group $aksname \
    --name $aksname \
    --node-count 1 \
    --enable-addons monitoring \
    --generate-ssh-keys

```

## Connect to the cluster
```bash
az aks install-cli

kubectl version

az aks get-credentials --resource-group $aksname --name $aksname

kubectl get nodes

```
Example output:
>NAME                       STATUS   ROLES   AGE     VERSION
>aks-nodepool1-31718369-0   Ready    agent   6m44s   v1.12.8

Create azure-vote.yaml
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: azure-vote-back
spec:
  replicas: 1
  selector:
    matchLabels:
      app: azure-vote-back
  template:
    metadata:
      labels:
        app: azure-vote-back
    spec:
      nodeSelector:
        "beta.kubernetes.io/os": linux
      containers:
      - name: azure-vote-back
        image: redis
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 250m
            memory: 256Mi
        ports:
        - containerPort: 6379
          name: redis
---
apiVersion: v1
kind: Service
metadata:
  name: azure-vote-back
spec:
  ports:
  - port: 6379
  selector:
    app: azure-vote-back
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: azure-vote-front
spec:
  replicas: 1
  selector:
    matchLabels:
      app: azure-vote-front
  template:
    metadata:
      labels:
        app: azure-vote-front
    spec:
      nodeSelector:
        "beta.kubernetes.io/os": linux
      containers:
      - name: azure-vote-front
        image: microsoft/azure-vote-front:v1
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 250m
            memory: 256Mi
        ports:
        - containerPort: 80
        env:
        - name: REDIS
          value: "azure-vote-back"
---
apiVersion: v1
kind: Service
metadata:
  name: azure-vote-front
spec:
  type: LoadBalancer
  ports:
  - port: 80
  selector:
    app: azure-vote-front
```

## Deploy the application 

```bash
kubectl apply -f azure-vote.yaml
```

Example output:
>>deployment "azure-vote-back" created
>>service "azure-vote-back" created
>>deployment "azure-vote-front" created
>>service "azure-vote-front" created


## Test the application

```bash
kubectl get service azure-vote-front --watch
```

Example output:
>NAME               TYPE           CLUSTER-IP   EXTERNAL-IP   PORT(S)        AGE
>azure-vote-front   LoadBalancer   10.0.37.27   <pending>     80:30572/TCP   6s

## List of pods
```bash
kubectl get pods -o wide
```
Example output:
>NAME                                READY   STATUS    RESTARTS   AGE     IP            NODE                       NOMINATED NODE
>azure-vote-back-7fb47b8f6d-2jhsp    1/1     Running   0          3h17m   10.244.0.12   aks-nodepool1-10885022-0   <none>
>azure-vote-front-7dbf9f5dfb-55bv8   1/1     Running   0          3h17m   10.244.0.13   aks-nodepool1-10885022-0   <none>

## Delete
```bash
az group delete --name $aksname --yes --no-wait
```
__More detail:__ 
- https://docs.microsoft.com/en-us/azure/aks/virtual-kubelet 
- https://docs.microsoft.com/en-us/azure/aks/tutorial-kubernetes-scale#autoscale-pods 

