
## Create an Event Hubs namespace. Specify a name for the Event Hubs namespace.

```bash
eventhubnamespace=az300evhub$RANDOM

az group create --name $eventhubnamespace -l southeastasia

az eventhubs namespace create --name $eventhubnamespace \ 
--resource-group $eventhubnamespace -l southeastasia

```

--- 

## Create an event hub. Specify a name for the event hub. 

```bash
eventhubname=myfirsthub

az eventhubs eventhub create --name $eventhubname \
--resource-group $eventhubnamespace --namespace-name $eventhubnamespace

eventhubnamespace=az300evhub10069

```

---

## Get Connection String

```bash
az eventhubs namespace authorization-rule keys list --resource-group $eventhubnamespace --namespace-name $eventhubnamespace --name RootManageSharedAccessKey

```

The connection string template looks like:
>Endpoint=sb://<FQDN>/;SharedAccessKeyName=<KeyName>;SharedAccessKey=<KeyValue>

---

### Create Nodejs application to Send / Receive message

Create Nodejs folder and install package

```bash
mkdir eventhub_nodejs
cd eventhub_nodejs

npm install @azure/event-hubs
npm install @azure/event-processor-host

```

__Create Send Events (send.js) file__

```nodejs
const { EventHubClient } = require("@azure/event-hubs");

// Define connection string and the name of the Event Hub
const connectionString = "";
const eventHubsName = "";

async function main() {
  const client = EventHubClient.createFromConnectionString(connectionString, eventHubsName);

  for (let i = 0; i < 100; i++) {
    const eventData = {body: `Event ${i}`};
    console.log(`Sending message: ${eventData.body}`);
    await client.send(eventData);
  }

  await client.close();
}

main().catch(err => {
  console.log("Error occurred: ", err);
});
```

Optional:
```nodejs
const { EventHubClient } = require("@azure/event-hubs");

// Define connection string and the name of the Event Hub
const connectionString = "Endpoint=sb://az300evhub10069.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=QdpYM+rATsozj1xW8vHkxWsq0jX4axEImNPr9akjAeM=";
const eventHubsName = "myfirsthub";

async function main() {
  const client = EventHubClient.createFromConnectionString(connectionString, eventHubsName);

  for (let i = 0; i < 100; i++) {
    var windSpeed = 8 + (Math.random() * 4);
    
    const data = {body: JSON.stringify({ deviceId: 'myIoTSensor', windSpeed: windSpeed})};
    
    console.log(`Sending message: ${data.body}`);
    await client.send(data);
  }

  await client.close();
}

main().catch(err => {
  console.log("Error occurred: ", err);
});

```

Replace connectionString and eventHubsName

Run command
>node send.js


__Create Receive events (receive.js) file__
```nodejs
const { EventHubClient, delay } = require("@azure/event-hubs");

// Define connection string and related Event Hubs entity name here
const connectionString = "";
const eventHubsName = "";

async function main() {
  const client = EventHubClient.createFromConnectionString(connectionString, eventHubsName);
  const allPartitionIds = await client.getPartitionIds();
  const firstPartitionId = allPartitionIds[0];

  const receiveHandler = client.receive(firstPartitionId, eventData => {
    console.log(`Received message: ${eventData.body} from partition ${firstPartitionId}`);
  }, error => {
    console.log('Error when receiving message: ', error)
  });

  // Sleep for a while before stopping the receive operation.
  await delay(15000);
  await receiveHandler.stop();

  await client.close();
}

main().catch(err => {
  console.log("Error occurred: ", err);
});
```
Replace connectionString and eventHubsName

Run command
>node send.js

