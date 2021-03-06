## Index
- [COMPUTE](https://github.com/SmithMMTK/home/blob/master/Az-300/measureupprep.md#compute)
    - [Create a managed image of a generalized VM in Azure](https://github.com/SmithMMTK/home/blob/master/Az-300/measureupprep.md#create-a-managed-image-of-a-generalized-vm-in-azure)
    - [Auto-Scale](https://github.com/SmithMMTK/home/blob/master/Az-300/measureupprep.md#auto-scale)
- [APPLICATION](https://github.com/SmithMMTK/home/blob/master/Az-300/measureupprep.md#application)
    - [Functions](https://github.com/SmithMMTK/home/blob/master/Az-300/measureupprep.md#functions)
    - [Container](https://github.com/SmithMMTK/home/blob/master/Az-300/measureupprep.md#container)
    - [Azure messaging services](https://github.com/SmithMMTK/home/blob/master/Az-300/measureupprep.md#azure-messaging-services)
    - [Azure Service Bus](https://github.com/SmithMMTK/home/blob/master/Az-300/measureupprep.md#azure-service-bus)
    - [Azure App Services](https://github.com/SmithMMTK/home/blob/master/Az-300/measureupprep.md#azure-app-service)
- [STORAGE](https://github.com/SmithMMTK/home/blob/master/Az-300/measureupprep.md#storage)
    - [Storage Service](https://github.com/SmithMMTK/home/blob/master/Az-300/measureupprep.md#azure-storage-service)
    - [Cosmos DB](https://github.com/SmithMMTK/home/blob/master/Az-300/measureupprep.md#cosmos-db)
    - [SQL Database Elastic Pool](https://github.com/SmithMMTK/home/blob/master/Az-300/measureupprep.md#sql-database-elastic-pool)
- [NETWORKING](https://github.com/SmithMMTK/home/blob/master/Az-300/measureupprep.md#networking)
    - [Application Gateway](https://github.com/SmithMMTK/home/blob/master/Az-300/measureupprep.md#application-gateway)
    - [Load Balancer](https://github.com/SmithMMTK/home/blob/master/Az-300/measureupprep.md#load-balancer---overview)
    - [Networking Options](https://github.com/SmithMMTK/home/blob/master/Az-300/measureupprep.md#networking-options)
- [SECURITY](https://github.com/SmithMMTK/home/blob/master/Az-300/measureupprep.md#security)
    - [Identity Protection](https://github.com/SmithMMTK/home/blob/master/Az-300/measureupprep.md#identity-protection)
    - [Managed Identities for Azure Resources](https://github.com/SmithMMTK/home/blob/master/Az-300/measureupprep.md#managed-identities-for-azure-resources)
    - [Azure AD Device Identity](https://github.com/SmithMMTK/home/blob/master/Az-300/measureupprep.md#azure-ad-device-identity)
    - [Access Review](https://github.com/SmithMMTK/home/blob/master/Az-300/measureupprep.md#access-review---overview)
    - [Key Vault](https://github.com/SmithMMTK/home/blob/master/Az-300/measureupprep.md#key-vault)
    - [Role-based access control (RBAC)](https://github.com/SmithMMTK/home/blob/master/Az-300/measureupprep.md#role-based-access-control-rbac)
- [AUTOMATION](https://github.com/SmithMMTK/home/blob/master/Az-300/measureupprep.md#automation)

https://github.com/SmithMMTK/home/blob/master/Az-300/measureupprep.md#migrate-hyper-v-vm-to-azure

---
### COMPUTE 

#### [Create a managed image of a generalized VM in Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/capture-image-resource)
A managed image resource can be created from a generalized virtual machine (VM) that is stored as either a managed disk or an unmanaged disk in a storage account. The image can then be used to create multiple VMs.

Prepare | Create image | Create VM from image
 --- | --- | --- 
 sysprep | get-AzVm | new-AzVm -imageName "name"
stop-AzVm | new-AzImageConfig | 
set-AzVm //_make vm to __Generalize___ | new-AzImage |

#### [Migrate Hyper-V VM to Azure](https://docs.microsoft.com/en-us/azure/site-recovery/migrate-tutorial-on-premises-azure)
- __Create__ Recovery Services vault
- Set __Protection goal__ to migration from on-premise to Azure
- Create __Hyper-V site__ and add to VM
- Install __Site Recovery Agent__ on local VM
- Register Hyper-V site in vault


#### [Auto Scale](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/autoscale-best-practices)

Auto Scale concept:

![alt text](https://docs.microsoft.com/en-us/azure/azure-monitor/media/overview/autoscale.png)


__Before Scaling down__, autoscale tries to estimate what the final state will be if it scaled in example:
>- Current Instance = 3
>- Default = 2
>- Scale-up when Avg CPU > 80
>- Scale-down when Avg CPU < 60
>- Average load reduce to 75, (75x3) / 2 = 112.5 => No Scale-down
>- Averge load reduce to 50, (50x3) / 2 = 75 => Scale-down by 1

__Combination of rules__
>- Scale-Out is __OR__, mean when Any rules is met.
>- Scale-In is __AND__, mean when All rules is met.


__Auto Scale Rule__
- Scale-Out
    > Objective: Over 10 minutes period, the maximum CPU time should not exceed 80%. If the does, the app should scale out across three VMs.
    >- Time aggregation: Maximum
    >- Metric name: CPU Percentage (_1 minute time grain_)
    >- Time grain statistic: Average
    >- Operator: Greater than
    >- Threshold: 80
    >- Duration (in minutes): 10
    >- Actions: Increase count to
    >    - Increase count by: // for add additional instance
    >- Instance count: 3
- Scale-In
    > Objective: If the average minimum CPU time is below 20% over a five minute period, one VM should be removed.
    >- Time aggregation: Average
    >- Metric name: CPU Percentage (_1 minute time grain_)
    >- Time grain statistic: Minimum
    >- Operator: Less than
    >- Threshold: 20
    >- Duration (in minutes): 5
    >- Actions: Decrease count by: 1
    >- Instance count: 3

- __Autoscale setting schema__ ([detail](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/autoscale-understanding-settings#autoscale-setting-schema))
    - __Time aggregation__ : The aggregation method used to aggregate the sampled metrics. For example, TimeAggregation = “Average” should aggregate the sampled metrics by taking the average. In the preceding case, take the ten 1-minute samples, and average them.

    - __Time grain statistic__ : The aggregation method within the timeGrain period. For example, statistic = “Average” and timeGrain = “PT1M” means that the metrics should be aggregated every 1 minute, by taking the average. This property dictates how the metric is sampled.

    - __Aggregation type__ ([detail](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-autoscale-overview))
        - Average
        - Minimum
        - Maximum
        - Total
        - Last
        - Count


#### [Azure Monitor](https://docs.microsoft.com/en-us/azure/azure-monitor/)
The following diagram gives a high-level view of Azure Monitor. At the center of the diagram are the data stores for metrics and logs, which are the two fundamental types of data use by Azure Monitor.

![alt text](https://docs.microsoft.com/en-us/azure/azure-monitor/media/overview/overview.png)

All data collected by Azure Monitor fits into one of two fundamental types, metrics and logs.
- __Metrics__ : Metrics are __numerical values__ that describe some aspect of a system at a particular point in time. They are lightweight and capable of supporting near real-time scenarios.
- __Logs__ : Logs contain different kinds of data organized into __records with different sets of properties for each type__. Telemetry such as events and traces are stored as logs in addition to performance data so that it can all be combined for analysis.


__Azure Monitor for VM__ ([detail](https://docs.microsoft.com/en-us/azure/azure-monitor/insights/vminsights-overview))

Monitors your Azure virtual machines (VM) at scale by analyzing the performance and health of your Windows and Linux VMs, including their different processes and interconnected dependencies on other resources and external processes. 

![alt text](https://docs.microsoft.com/en-us/azure/azure-monitor/media/overview/vm-insights.png)

>Note: Azure Monitoring unable to monitor disk space remaining.

---
### APPLICATION

#### [On-Premises data gateway](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-gateway-install#how-does-the-gateway-work)

The data gateway facilitates quick and secure communication between your logic app, the gateway cloud service, and your on-premises data source. The gateway cloud service encrypts and stores your data source credentials and gateway details. The service also routes queries and their results between your logic app, the on-premises data gateway, and your data source on premises

![alt text](https://docs.microsoft.com/en-us/azure/logic-apps/media/logic-apps-gateway-install/how-on-premises-data-gateway-works-flow-diagram.png)

__Detail Instruction__ ([link](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-gateway-connection))

![alt text](https://docs.microsoft.com/en-us/azure/logic-apps/media/logic-apps-gateway-connection/logic-app-find-api-connections.png)


#### [Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-overview)

Azure Functions is a solution for easily running small pieces of code, or "functions," in the cloud. You can write just the code you need for the problem at hand, without worrying about a whole application or the infrastructure to run it. Functions can make development even more productive, and you can use your development language of choice, such as C#, F#, Node.js, Java, or PHP. Pay only for the time your code runs and trust Azure to scale as needed.

__Durable Functions__ ([detail](https://docs.microsoft.com/en-us/azure/azure-functions/durable/durable-functions-overview))

_Durable Functions_ are an extension of Azure Functions that lets you write __stateful functions__ in a serverless environment. The extension manages state, checkpoints, and restarts for you.

__Application patterns__ ([detail](https://docs.microsoft.com/en-us/azure/azure-functions/durable/durable-functions-overview#application-patterns))
- Chaining
- Fan-out/fan-in
- Async HTTP APIs
- Monitoring
- Human interaction

__Functions Type__ ([detail](https://docs.microsoft.com/en-us/azure/azure-functions/durable/durable-functions-types-features-overview))

![alt text](https://docs.microsoft.com/en-us/azure/azure-functions/durable/media/durable-functions-types-features-overview/durable-concepts.png)

>- Activity = Perform actions __[ActivityTrigger]__
>- Orchestrator = Describe how actions is work in order __[OrchestratorTrigger]__
>- Client = Trigger functions that creat new instance of an orchestration __[OrchestrationClient]__ (e.g. Queue, HTTP, Event Stream trigger)


__Code Example:__

__orchestrationsClient__
```c#
     [FunctionName("DurableFunctionsOrchestrationCSharp_HttpStart")]
        public static async Task<HttpResponseMessage> HttpStart(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post")]HttpRequestMessage req,
            [OrchestrationClient]DurableOrchestrationClient starter,
            ILogger log)
        {
            // Function input comes from the request content.
            string instanceId = await starter.StartNewAsync("DurableFunctionsOrchestrationCSharp", null);

            log.LogInformation($"Started orchestration with ID = '{instanceId}'.");

            return starter.CreateCheckStatusResponse(req, instanceId);
        }
```

__orchestrationTrigger__
```c#
    [FunctionName("DurableFunctionsOrchestrationCSharp")]
        public static async Task<List<string>> RunOrchestrator(
            [OrchestrationTrigger] DurableOrchestrationContext context)
        {
            var outputs = new List<string>();

            // Replace "hello" with the name of your Durable Activity Function.
            outputs.Add(await context.CallActivityAsync<string>("DurableFunctionsOrchestrationCSharp_Hello", "Tokyo"));
            outputs.Add(await context.CallActivityAsync<string>("DurableFunctionsOrchestrationCSharp_Hello", "Seattle"));
            outputs.Add(await context.CallActivityAsync<string>("DurableFunctionsOrchestrationCSharp_Hello", "London"));

            // returns ["Hello Tokyo!", "Hello Seattle!", "Hello London!"]
            return outputs;
        }
```

__activitiyTrigger__
```c#
    [FunctionName("DurableFunctionsOrchestrationCSharp_Hello")]
        public static string SayHello([ActivityTrigger] string name, ILogger log)
        {
            log.LogInformation($"Saying hello to {name}.");
            return $"Hello {name}!";
        }
```

__Singleton orchestrators__ ([detail](https://docs.microsoft.com/en-us/azure/azure-functions/durable/durable-functions-singletons))

For background jobs you often need to ensure that only one instance of a particular orchestrator runs at a time. This can be done in Durable Functions by assigning a specific instance ID to an orchestrator when creating it

```c#
    [FunctionName("HttpStartSingle")]
    public static async Task<HttpResponseMessage> RunSingle(
        [HttpTrigger(AuthorizationLevel.Function, methods: "post", Route = "orchestrators/{functionName}/{instanceId}")] HttpRequestMessage req,
        [OrchestrationClient] DurableOrchestrationClient starter,
        string functionName,
        string instanceId,
        ILogger log)
    {
        // Check if an instance with the specified ID already exists.
        var existingInstance = await starter.GetStatusAsync(instanceId);
        if (existingInstance == null)
        {
            // An instance with the specified ID doesn't exist, create one.
            dynamic eventData = await req.Content.ReadAsAsync<object>();
            await starter.StartNewAsync(functionName, instanceId, eventData);
            log.LogInformation($"Started orchestration with ID = '{instanceId}'.");
            return starter.CreateCheckStatusResponse(req, instanceId);
        }
        else
        {
            // An instance with the specified ID exists, don't create one.
            return req.CreateErrorResponse(
                HttpStatusCode.Conflict,
                $"An instance with ID '{instanceId}' already exists.");
        }
}
```
>Key interesting area in code
>- OrchestrationClient
>- starter.GetStatusAsync(instanceId)
>- starter.StartNewAsync(functionName, instanceId, eventData)


__Manage connections in Azure Functions__ ([detail](https://docs.microsoft.com/en-us/azure/azure-functions/manage-connections))
Functions in a function app share resources. Among those shared resources are connections: HTTP connections, database connections, and connections to services such as Azure Storage. When many functions are running concurrently, it's possible to run out of available connections. This article explains how to code your functions to avoid using more connections than they need.

```c#
    #r "Microsoft.Azure.Documents.Client"
    using Microsoft.Azure.Documents.Client;

    private static Lazy<DocumentClient> lazyClient = new Lazy<DocumentClient>(InitializeDocumentClient);
    private static DocumentClient documentClient => lazyClient.Value;

    private static DocumentClient InitializeDocumentClient()
    {
        // Perform any initialization here
        var uri = new Uri("example");
        var authKey = "authKey";      
        return new DocumentClient(uri, authKey);
    }

    public static async Task Run(string input)
    {
        Uri collectionUri = UriFactory.CreateDocumentCollectionUri("database", "collection");
        object document = new { Data = "example" };
        await documentClient.UpsertDocumentAsync(collectionUri, document);       
        // Rest of function
    }
```
>Key interesting area in code
>- private static DocumentClient documentClient
>- new Lazy<DocumentClient>(InitializeDocumentClient)
>- new DocumentClient(uri, authKey);




#### [Container](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-overview)

__Build the container image__

Windows environment
```docker
    FROM windows/iis
    RUN mkdir -p c:\app
    COPY app c:\app
    WORKDIR c:\app
    RUN npm install
    CMD node index.js
```


Linux environment
    
    git clone https://github.com/Azure-Samples/aci-helloworld.git

```docker
    FROM node:8.9.3-alpine
    RUN mkdir -p /Users/smithm/app
    COPY ./app/* /Users/smithm/app/
    WORKDIR /Users/smithm/app
    RUN npm install
    CMD node /Users/smithm/app/index.js
```

Set a command or process that will run each time a container is run __CMD__ 

    docker build ./aci-helloworld -t aci-tutorial-app

__Hands-On: [Create and deploy container image](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-tutorial-prepare-app)__

__Azure Web App for Continers__ 

```bash
    az webapp config container set // Change container image
    az webapp deployment container // Enable CD
    az webapp deploymnet source // Enable Git
```

__Web Jobs__ is a feature of Azure App Service that enables you to run a program or script in the same context as a web app, API app, or mobile app. There is no additional cost to use WebJobs ([detail](https://docs.microsoft.com/en-us/azure/app-service/webjobs-create)).


#### [Azure messaging services](https://docs.microsoft.com/en-us/azure/event-grid/compare-messaging-services)

Azure offers three services that assist with delivering event messages throughout a solution. These services are:

- [Event Grid](https://docs.microsoft.com/en-us/azure/event-grid/)
- [Event Hubs](https://docs.microsoft.com/en-us/azure/event-hubs/)
- [Service Bus](https://docs.microsoft.com/en-us/azure/service-bus-messaging/)

__Comparison of services__

| __Service__ | __Purpose__ | __Type__ | __When to use__ |
|---|---|---|---|
| Event Grid | Reactive programming | Event distribution (discrete) | React to status changes |
| Event Hubs | Big data pipeline | Event streaming (series) | Telemetry and distributed data streaming |
| Service Bus | High-value enterprise messaging | Message | Order processing and financial transactions |

#### [Azure Service Bus](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-messaging-overview) 

Microsoft Azure Service Bus is a fully managed enterprise integration message broker. Service Bus is most commonly used to decouple applications and services from each other, and is a reliable and secure platform for asynchronous data and state transfer.

__Concept__
- __Namespaces__ : A namespace is a scoping container for all messaging components. Multiple queues and topics can reside within a single namespace, and namespaces often serve as application containers.

- __Queues__ : Messages are sent to and received from queues. Queues enable you to store messages until the receiving application is available to receive and process them.

    >__Important: One Application or Client per Queue only.__

![alt text](https://docs.microsoft.com/en-us/azure/service-bus-messaging/media/service-bus-messaging-overview/about-service-bus-queue.png)

- __Topics__ : You can also use topics to send and receive messages. While a queue is often used for point-to-point communication, topics are useful in publish/subscribe scenarios. 

    >__Important: Multiple-Applications or Clients to same Topic supported.__

![alt text](https://docs.microsoft.com/en-us/azure/service-bus-messaging/media/service-bus-messaging-overview/about-service-bus-topic.png)

```powershell
    # Create a resource group 
    New-AzResourceGroup –Name my-resourcegroup –Location eastus

    # Create a Messaging namespace
    New-AzServiceBusNamespace -ResourceGroupName my-resourcegroup `
    -NamespaceName namespace-name -Location eastus

    # Create a queue 
    New-AzServiceBusQueue -ResourceGroupName my-resourcegroup `
    -NamespaceName namespace-name -Name queue-name -EnablePartitioning $False

    # Get primary connection string (required in next step)
    Get-AzServiceBusKey -ResourceGroupName my-resourcegroup `
    -Namespace namespace-name -Name RootManageSharedAccessKey
```

The states that can be set for a queue are:

- Active: The queue is active.
- Disabled: The queue is suspended.
- SendDisabled: The queue is partially suspended, with receive being permitted.
- ReceiveDisabled: The queue is partially suspended, with send being permitted

```bash
    az servicebus namespace create
    --name measureup --resource-group sbrg 
    --location southeastasia

    az servicebus topic create
    --name converter --resource-group sbrg
    --namespace_name measureup
```

#### Azure App Service

__[Web server diagnostics and application diagnostics](https://docs.microsoft.com/en-us/azure/app-service/troubleshoot-diagnostic-logs#whatisdiag)__
- __Detailed Error Logging__ - Detailed information for any request that results in HTTP status code 400 or greater. It may contain information that can help determine why the server returned the error code. One __HTML file__ is generated for each error in the app's file system, and up to 50 errors (files) are retained. When the number of HTML files exceed 50, the oldest 26 files are automatically deleted.

- __Failed Request Tracing__ - Detailed information on failed requests, including a trace of the IIS components used to process the request and the time taken in each component. It's useful if you want to improve site performance or isolate a specific HTTP error. One folder is generated for each error in the app's file system. File retention policies are the same as the detailed error logging above.

- __Web Server Logging__ - Information about HTTP transactions using the W3C extended log file format. It's useful when determining overall site metrics such as the number of requests handled or how many requests are from a specific IP address.

__[Web Jobs Runtime](https://docs.microsoft.com/en-us/azure/app-service/webjobs-sdk-how-to#webjobs-host)__
    
```c#
    static void Main(string[] args)
    {
        var _storageConn = ConfigurationManager
            .ConnectionStrings["MyStorageConnection"].ConnectionString;
    
        //// Dashboard logging is deprecated; use Application Insights.
        //var _dashboardConn = ConfigurationManager
        //    .ConnectionStrings["MyDashboardConnection"].ConnectionString;
    
        JobHostConfiguration config = new JobHostConfiguration();
        config.StorageConnectionString = _storageConn;
        //config.DashboardConnectionString = _dashboardConn;
        JobHost host = new JobHost(config);
        host.RunAndBlock();
    }
```

Code Highlight: 
>host.RunAndBlock(); // for manual trigger


---
### STORAGE
#### [Azure Storage Service](https://docs.microsoft.com/en-us/azure/storage/common/storage-introduction)

- Hot - Optimized for storing data that is accessed frequently.
- Cool - Optimized for storing data that is infrequently accessed and stored for at least __30 days__.
- Archive - Optimized for storing data that is rarely accessed and stored for at least __180 days__ with flexible latency requirements (on the order of hours).
    >__Only support at Blob level.__

    __Blob-level tiering billing__

    | Operation | Write Charges (Operation + Access) | Read Charges (Operation + Access) |
    |----|---|---|
    | SetBlobTier Direction | hot->cool, hot->archive, cool->archive | archive->cool, archive->hot, cool->hot |

__Azure Storage redundancy__ ([detail](https://docs.microsoft.com/en-us/azure/storage/common/storage-redundancy))
- LRS : 3 copies within region
- GRS : 3 copies on remote region
- RA-GRS : 3 copies on remote region with read access

#### [Cosmos DB](https://docs.microsoft.com/en-us/azure/cosmos-db/introduction)

[Consistency, availability, and performance tradeoffs](https://docs.microsoft.com/en-us/azure/cosmos-db/consistency-levels-tradeoffs)

You can choose from five well-defined models on the consistency spectrum. From strongest to weakest, the models are:

- Strong
- Bounded staleness
- Session
- Consistent prefix
- Eventual

Consistency levels and latency
- The read latency for all consistency levels is always guaranteed to be __less than 10 milliseconds__ at the 99th percentile.
    - The average read latency, at the 50th percentile, is typically 2 milliseconds or less
- The write latency for all consistency levels is always guaranteed to be __less than 10 milliseconds__ at the 99th percentile.
    - The average write latency, at the 50th percentile, is usually 5 milliseconds or less

[Consistency levels and data durability](https://docs.microsoft.com/en-us/azure/cosmos-db/consistency-levels)
![alt text](https://docs.microsoft.com/en-us/azure/cosmos-db/media/consistency-levels/five-consistency-levels.png)

__[Physical partitions](https://docs.microsoft.com/en-us/azure/cosmos-db/partition-data)__
![alt text](https://docs.microsoft.com/en-us/azure/cosmos-db/media/partition-data/logical-partitions.png)

__Choosing a partition key__ ([detail](https://docs.microsoft.com/en-us/azure/cosmos-db/partitioning-overview#choose-partitionkey))

- A single logical partition has an upper limit of 10 GB of storage.

- Azure Cosmos containers have a minimum throughput of 400 request units per second (RU/s). Requests to the same partition key can't exceed the throughput that's allocated to a partition. If requests exceed the allocated throughput, requests are rate-limited. So, it's important to pick a partition key that doesn't result in "hot spots" within your application.

- Choose a partition key that has a wide range of values and access patterns that are evenly spread across logical partitions. This helps spread the data and the activity in your container across the set of logical partitions, so that resources for data storage and throughput can be distributed across the logical partitions.

- Choose a partition key that spreads the workload evenly across all partitions and evenly over time. Your choice of partition key should balance the need for efficient partition queries and transactions against the goal of distributing items across multiple partitions to achieve scalability.

- Candidates for partition keys might include properties that appear frequently as a filter in your queries. Queries can be efficiently routed by including the partition key in the filter predicate.


#### [SQL Database Elastic Pool](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-elastic-pool)

A common application pattern is to provision a single database for each customer. But different customers often have varying and unpredictable usage patterns, and it is difficult to predict the resource requirements of each individual database user. Traditionally, you had two options:

- Over-provision resources based on peak usage and over pay, or
- Under-provision to save cost, at the expense of performance and customer satisfaction during peaks.

Elastic pools solve this problem by ensuring that databases get the performance resources they need when they need it. They provide a simple resource allocation mechanism within a predictable budget.

![alt text](https://docs.microsoft.com/en-us/azure/sql-database/media/sql-database-elastic-pool/twenty-databases.png)

> __Case Study:__
> - Support 2 dbs peaking concurrently at 70 DTUs
> - Maximum of as near to 75 DTUs
> - Minimum the DTUs that are guaranteed to all databases in the pool
> - Minimize pool costs and configuration
> DTU requirement = 250
> DTU Min = 0, DTU Max = 75

__Choose the right SQL Server option in Azure__ ([detail](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-paas-vs-sql-server-iaas))

SQL Server on VM | Managed instance in SQL Database	| Single database / elastic pool in SQL Database
--- | --- | ---
You have full control over the SQL Server engine. Up to 99.95% availability | High compatibility with SQL Server on-premises. 99.99% availability guaranteed. __Limited to vCPU purchasing model only.__ | The most commonly used SQL Server features are available. 99.99% availability guaranteed. Built-in backups, patching, recovery.




---

### NETWORKING
#### [Application Gateway](https://docs.microsoft.com/en-us/azure/application-gateway/overview)
With Application Gateway, you can make routing decisions based on additional attributes of an HTTP request, such as URI path or host headers. For example, you can route traffic based on the incoming URL. So if /images is in the incoming URL, you can route traffic to a specific set of servers (known as a pool) configured for images. If /video is in the URL, that traffic is routed to another pool that's optimized for videos.
    
![alt text](https://docs.microsoft.com/en-us/azure/application-gateway/media/application-gateway-url-route-overview/figure1-720.png)


__Route web traffic based on the URL using Azure PowerShell__ ([detail](https://docs.microsoft.com/en-us/azure/application-gateway/tutorial-url-route-powershell))

![alt text](https://docs.microsoft.com/en-us/azure/application-gateway/media/tutorial-url-route-powershell/scenario.png)

__How an application gateway works__ ([detail](https://docs.microsoft.com/en-us/azure/application-gateway/how-application-gateway-works))

![alt text](https://docs.microsoft.com/en-us/azure/application-gateway/media/how-application-gateway-works/how-application-gateway-works.png)



- Set up the network
- Create __listeners__, __URL path map__, and __rules__
- Create scalable backend pools

__High Level Flow__
```powershell
    $gateway = Get-AzApplicationGateway
        -ResourceGroupName myRG
        -Name myAppGW

    $backendlistener = Get-AzApplicationGatewayHttpListener
        -ApplicationGateway $gateway
        -Name backendListener

    $config = Get-AzApplicationGatewayUrlPathMapConfig
        -ApplicationGateway $gateway
        -Name urlpathmap
    
    Add-AzApplicationGatewayRequstRoutingRule
        -ApplicationGateway $gateway
        -Name rule2
        -RuleType PathBasedRouting
        -HttpListener $backendlistener
        -UrlPathMap $config
    
    Set-AzApplicationsGateway
        -AppcliationGateway $gateway
```

- __Add-AzApplicationGatewayUrlPathMapConfig__
    ```powershell
        Add-AzApplicationGatewayUrlPathMapConfig `
            -ApplicationGateway $appgw `
            -Name urlpathmap `
            -PathRules $imagePathRule, $videoPathRule `
            -DefaultBackendAddressPool $defaultPool `
            -DefaultBackendHttpSettings $poolSettings
    ```


- __New-AzApplicationGatewayPathRuleConfig__
    ```powershell
        $imagePathRule = New-AzApplicationGatewayPathRuleConfig `
            -Name imagePathRule `
            -Paths "/images/*" `
            -BackendAddressPool $imagePool `
            -BackendHttpSettings $poolSettings
    ```




#### [Load Balancer - Overview](https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-overview)

By default, Load Balancer uses a 5-tuple hash composed of source IP address, source port, destination IP address, destination port, and IP protocol number to map flows to available servers. You can choose to create affinity to a specific source IP address by opting into a 2- or 3-tuple hash for a given rule. All packets of the same packet flow arrive on the same instance behind the load-balanced front end. When the client initiates a new flow from the same source IP, the source port changes. As a result, the 5-tuple might cause the traffic to go to a different backend endpoint.

![alt text](https://docs.microsoft.com/en-us/azure/load-balancer/media/load-balancer-overview/load-balancer-distribution.png)

[How to: Create Load Balancer by PowerShell](https://docs.microsoft.com/en-us/azure/load-balancer/quickstart-create-standard-load-balancer-powershell)

If you choose to install and use PowerShell locally, this article requires the Azure PowerShell module version 5.4.1 or later. Run Get-Module -ListAvailable Az to find the installed version.

```powershell
    $nb = New-AzLoadBalancer `
    -ResourceGroupName $rgName `
    -Name 'MyLoadBalancer' `
    -SKU Standard `
    -Location $location `
    -FrontendIpConfiguration $feip `
    -BackendAddressPool $bepool `
    -Probe $probe `
    -LoadBalancingRule $rule `
    -InboundNatRule $natrule1,$natrule2,$natrule3
```

```powershell
    $probe = New-AzLoadBalancerProbeConfig `
    -Name "myHealthProbe" `
    -RequestPath healthcheck2.aspx `
    -Protocol http `
    -Port 80 `
    -IntervalInSeconds 16 `
    -ProbeCount 2
```

```bash
      az network lb create \
      --resource-group myResourceGroupSLB \
      --name myLoadBalancer \
      --sku standard \
      --public-ip-address myPublicIP \
      --frontend-ip-name myFrontEnd \
      --backend-pool-name myBackEndPool
```

ExpressRoute lets you extend your on-premises networks into the Microsoft cloud over a private connection facilitated by a connectivity provider

#### [Networking Options](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview)

- [Hub-spoke topology](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke) The hub is a virtual network (VNet) in Azure that acts as a central point of connectivity to your on-premises network. The spokes are VNets that peer with the hub, and can be used to isolate workloads. 

![Alt Text](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/images/hub-spoke.png)

- [Express Route](https://docs.microsoft.com/en-us/azure/expressroute/expressroute-about-virtual-network-gateways)
ExpressRoute lets you extend your on-premises networks into the Microsoft cloud over a private connection facilitated by a connectivity provider

    > __Connect ExpressRoute to On-Premise__ ([detail](https://docs.microsoft.com/en-us/azure/expressroute/expressroute-howto-circuit-portal-resource-manager))
    > - Create an ExpressRoute circuit
    > - _Create a peering_ // _When use ISP offer only layer-2_
    > - Create an ExpressRoute VNet gateway
    > - Create a link between the circuit and the VNet.
    
    > Not required VPN Server.


- [VNet Peering](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-peering-overview) Virtual network peering enables you to seamlessly connect Azure virtual networks. Once peered, the virtual networks appear as one, for connectivity purposes. The traffic between virtual machines in the peered virtual networks is routed through the Microsoft backbone infrastructure, much like traffic is routed between virtual machines in the same virtual network, through private IP addresses only. Azure supports:

    - VNet peering - connecting VNets within the same Azure region
    - Global VNet peering - connecting VNets across Azure regions

- [VPN Gateway](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways) A VPN gateway is a specific type of virtual network gateway that is used to send encrypted traffic between an Azure virtual network and an on-premises location over the public Internet.
    - [Point-to-Site VPN](https://docs.microsoft.com/en-us/azure/vpn-gateway/point-to-site-about)
    - [Site-to-Site VPN](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpn-devices)

__Changing the IP address of an IP configuration__
```powershell
    $vnet = Get-AzureRmVirtualNetwork -Name myvnet 
        -ResourceGroupName myrg

    $subnet = Get-AzureRmVirtualNetworkSubnetConfig -Name mysubnet 
        -VirtualNetwork $vnet
    
    $nic = Get-AzureRmNetworkInterface -Name nic1 -ResourceGroupName myrg

    $nic | Set-AzureRmNetworkInterfaceIpConfig -Name ipconfig1 
        -PrivateIpAddress 10.0.0.11 -Subnet $subnet
        -Primary

    $nic | Set-AzureRmNetworkInterface
```

---

### SECURITY

#### [Identity Protection](https://docs.microsoft.com/en-us/azure/active-directory/identity-protection/overview)

Azure Active Directory Identity Protection is more than a monitoring and reporting tool. To protect your organization's identities, you can configure risk-based policies that automatically respond to detected issues when a specified risk level has been reached.

__Identity Protection roles__

Role | Can do | Cannot do
--- | --- | ---
Global administrator | Full access to Identity Protection, Onboard Identity Protection | 
Security administrator | Full access to Identity Protection | Onboard Identity Protection, reset passwords for a user
Security reader | Read-only access to Identity Protection | Onboard Identity Protection, remediate users, configure policies, reset passwords 

__Policies__ ([detail](https://docs.microsoft.com/en-us/azure/active-directory/identity-protection/overview#policies))

- __Multi-factor authentication registration policy__
    > Azure Multi-Factor Authentication provides a means to verify who you are using more than just a username and password. It provides a second layer of security to user sign-ins. In order for users to be able to respond to MFA prompts, they must first register for Azure Multi-Factor Authentication.
- __User risk policy__
    > Azure AD analyzes each sign-in of a user. The objective of the analysis is to detect suspicious actions that come along with the sign-in. In Azure AD, the suspicious actions the system can detect are also known as risk events. While some risk events can be detected in real-time, there are also risk events requiring more time. For example, to detect an impossible travel to atypical locations, the system requires an initial learning period of 14 days to __learn about a user's regular behavior__. There are several options to resolve detected risk events. For example, you can resolve individual risk events manually, or you can get them resolved using a sign-in risk or a user risk Conditional Access policy.
- __Sign-in risk policy__
    > Azure AD analyzes each sign-in of a user. The objective of the analysis is to detect suspicious actions that come along with the sign-in. For example, is the sign-in done using an anonymous IP address, or is the sign-in initiated from an unfamiliar location? In Azure AD, the suspicious actions the system can detect are also known as risk events. Based on the risk events that have been detected during a sign-in, Azure AD calculates a value. The value represents the probability (low, medium, high) that the sign-in is not performed by the legitimate user. The probability is called sign-in risk level.


__Configure Azure Multi-Factor Authentication settings__ ([detail](https://docs.microsoft.com/en-us/azure/active-directory/authentication/howto-mfa-mfasettings))

Feature | Description
--- | --- 
Account lockout | Temporarily lock accounts in the multi-factor authentication service if there are too many denied authentication attempts in a row. This feature only applies to users who enter a PIN to authenticate. (MFA Server)
Block/unblock users | Used to block specific users from being able to receive Multi-Factor Authentication requests. Any authentication attempts for blocked users are automatically denied. Users remain blocked for 90 days from the time that they are blocked.
Fraud alert | Configure settings related to users ability to report fraudulent verification requests
Notifications | Enable notifications of events from MFA Server.
OATH tokens	| Used in cloud-based Azure MFA environments to manage OATH tokens for users.
Phone call settings | Configure settings related to phone calls and greetings for cloud and on-premises environments.



#### [Managed identities for Azure resources](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview)

The feature provides Azure services with an automatically managed identity in Azure AD. You can use the identity to authenticate to any service that supports Azure AD authentication, including Key Vault, without any credentials in your code.

- Hands-on: [Windows VM with Managed Identities](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/tutorial-windows-vm-access-arm)
- Hands-on: [Linux VM with Managed Identities](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/tutorial-linux-vm-access-arm)
- Hadns-on: [Windows VM Access Storage Account via SAS](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/tutorial-windows-vm-access-storage-sas)

Quick-Steps ([detail:](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/tutorial-windows-vm-access-arm))
- Add role assignment (__Reader__) to __all resource groups__
- Use __Invoke__ cmdlet to get access token
    ```powershell
    $response = Invoke-WebRequest -Uri 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://management.azure.com/' 
    -Method GET -Headers @{Metadata="true"}

    $content = $response.Content | ConvertFrom-Json

    $ArmToken = $content.access_token
    ```
- Call Azure Resource Manager using access token
    ```powershell
    (Invoke-WebRequest -Uri https://management.azure.com/subscriptions/<SUBSCRIPTION ID>/resourceGroups/<RESOURCE GROUP>?api-version=2016-06-01 
    -Method GET -ContentType "application/json" 
    -Headers @{ Authorization ="Bearer $ArmToken"}).content
    ```

#### [Azure AD Device Identity](https://docs.microsoft.com/en-us/azure/active-directory/devices/)

Through devices in Azure AD, your users are getting access to your corporate assets. To protect your corporate assets, as an IT administrator, you want to manage these device identities in Azure AD. This enables you to make sure that your users are accessing your resources from devices that meet your standards for security and compliance.

__Device Identity__ ([detail](https://docs.microsoft.com/en-us/azure/active-directory/devices/overview))
- [Azure AD registered (Win10, iOS, Android, MacOS)](https://docs.microsoft.com/en-us/azure/active-directory/devices/concept-azure-ad-register)

- [Azure AD Joined (Win10)](https://docs.microsoft.com/en-us/azure/active-directory/devices/concept-azure-ad-join)
    - [Plan AD Joined implementation](https://docs.microsoft.com/en-us/azure/active-directory/devices/azureadjoin-plan)
        - Managed environment - A managed environment can be deployed either through Password Hash Sync or Pass Through Authentication with Seamless Single Sign On.
        
            These scenarios don't require you to configure a federation server for authentication.

        - Federated environment - A federated environment should have an identity provider that supports both WS-Trust and WS-Fed protocols:
            - __WS-Fed__: This protocol is required to join a device to Azure AD.
            - __WS-Trust__: This protocol is required to sign in to an Azure AD joined device.

- [Hybrid Azure AD Joined (Win7, Win8.1, Win10, WinSvr2008+)](https://docs.microsoft.com/en-us/azure/active-directory/devices/concept-azure-ad-join-hybrid)




#### [Access Review - Overview](https://docs.microsoft.com/en-us/azure/active-directory/governance/access-reviews-overview)
    
Azure Active Directory (Azure AD) __Access Reviews__ enable organizations to efficiently manage group memberships, access to enterprise applications, and role assignments. User's access can be reviewed on a regular basis to make sure only the right people have continued access [How to: Configure Access Review](https://docs.microsoft.com/en-us/azure/active-directory/governance/create-access-review).   

- Security group members, Office group members
- Assigned to a connected app

You can use Azure Active Directory (Azure AD) Privileged Identity Management (__PIM__) to create access reviews for privileged Azure AD roles.
- Azure AD role
- Azure resource role

#### [Key Vault](https://docs.microsoft.com/en-in/azure/key-vault/key-vault-overview)

Azure Key Vault helps solve the following problems:

- Secrets Management - Azure Key Vault can be used to Securely store and tightly control access to __tokens, passwords, certificates, API keys, and other secrets__
- Key Management - Azure Key Vault can also be used as a Key Management solution. Azure Key Vault makes it easy to create and control the __encryption keys used to encrypt your data.__
- Certificate Management - Azure Key Vault is also a service that lets you easily provision, manage, and deploy public and private Secure Sockets Layer/Transport Layer Security (SSL/TLS) certificates for use with Azure and your internal connected resources.
- Store secrets backed by Hardware Security Modules - The secrets and keys can be protected either by software or FIPS 140-2 Level 2 validates HSMs

[How-to: Create Secret by Power Shell](https://docs.microsoft.com/en-in/azure/key-vault/quick-create-powershell)

```powershell
    New-AzKeyVault -Name 'my-Vault' -ResourceGroupName 'myResourceGroup' -Location 'East US'

    $secretvalue = ConvertTo-SecureString 'hVFkk965BuUv' -AsPlainText -Force

    $secret = Set-AzKeyVaultSecret -VaultName 'my-Vault' -Name 'ExamplePassword' -SecretValue $secretvalue

    (Get-AzKeyVaultSecret -vaultName "my-Vault" -name "ExamplePassword").SecretValueText
```

__Use Azure Key Vault with an Azure web app in .NET__ ([detail](https://docs.microsoft.com/en-us/azure/key-vault/tutorial-net-create-vault-azure-web-app))

```c#
    async Task<string>GetConnectionString(string secretUri)
    {
        var provider = new AzureServiceTokenProvider();
        var callback = new KeyVaultClient.AuthenticationCallback(provider.KeyVaultTokenCallBack);
        var client = new KeyVaultClient(callback);
        var secreat = await client.GetSecret(secretUri);
        return secreat.Value;
    }
```

__Key generation plan__ ([detail](https://docs.microsoft.com/en-us/azure/storage/common/storage-security-guide#key-regeneration-plan))

1. Regenerate Key 2 to ensure that it is secure. You can do this in the Azure portal.
1. In all of the applications where the storage key is stored, change the storage key to use Key 2's new value. Test and publish the application.
1. After all of the applications and services are up and running successfully, regenerate Key 1. This ensures that anybody to whom you have not expressly given the new key will no longer have access to the storage account



#### [Role-based access control (RBAC)](https://docs.microsoft.com/en-us/azure/role-based-access-control/overview)
Access management for cloud resources is a critical function for any organization that is using the cloud. Role-based access control (RBAC) helps you manage who has access to Azure resources, what they can do with those resources, and what areas they have access to.

![Alt text](https://docs.microsoft.com/en-us/azure/role-based-access-control/media/overview/rbac-least-privilege.png)

__How RBAC works__ ([detail](https://docs.microsoft.com/en-us/azure/role-based-access-control/overview#how-rbac-works))

- Security principal : A security principal is an object that represents a user, group, service principal, or managed identity that is requesting access to Azure resources.

    ![Alt text](https://docs.microsoft.com/en-us/azure/role-based-access-control/media/overview/rbac-security-principal.png)

- Role definition : A role definition is a collection of permissions. It's sometimes just called a role. A role definition lists the operations that can be performed, such as read, write, and delete. Roles can be high-level, like owner, or specific, like virtual machine reader

    ![Alt text](https://docs.microsoft.com/en-us/azure/role-based-access-control/media/overview/rbac-role-definition.png)

- Scope : Scope is the set of resources that the access applies to. When you assign a role, you can further limit the actions allowed by defining a scope. 

    ![Alt text](https://docs.microsoft.com/en-us/azure/role-based-access-control/media/overview/rbac-scope.png)

- Role assignments : A role assignment is the process of attaching a role definition to a user, group, service principal, or managed identity at a particular scope for the purpose of granting access. Access is granted by creating a role assignment, and access is revoked by removing a role assignment

    ![Alt text](https://docs.microsoft.com/en-us/azure/role-based-access-control/media/overview/rbac-overview.png)


```bash
    az role definition create --role-definition customrole.json
    
    az role assignment create --role "App Svc Contributor" 
        --assignee-object-id "GUID"
        --assignee "user/group"
```

```json
    {
        "Actions" : [ ],
        "NotActions" : [ ],
        "DataActions" : [ 
            "Microsoft.Storage/storageAccounts/blobServices/containers/delete",
            "Microsoft.Storage/storageAccounts/blobServices/containers/read",
            "Microsoft.Storage/storageAccounts/blobServices/containers/write"],
        "NoDataActions" : [ "Exclusion" ]
    }

```

__Understand role definitions for Azure resources__ ([Detail](https://docs.microsoft.com/en-us/azure/role-based-access-control/role-definitions))






---

### AUTOMATION
- Resource Group and ARM Template Deployment
    ```powershell
        $resourceGroupName = Read-Host -Prompt "Enter the Resource Group name"
        $location = Read-Host -Prompt "Enter the location (i.e. centralus)"
        
        New-AzResourceGroup -Name $resourceGroupName -Location $location
        New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName `
        -TemplateUri https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-storage-account-create/azuredeploy.json
    ```

    >Two differrence parameters:
    >- New-AzResourceGroup __-Name__
    >- New-AzResourceGroupDeployment __-ResourceGroupName__
    
- Invoke SQL Command
    ```powershell
        Invoke-Sqlcmd -Query "SELECT GETDATE() AS TimeOfQuery"
        -ServerInstance "MyComputer\MainInstance"
    ```

- Sets properties for a database, or moves an existing database into an elastic pool ([detail](https://docs.microsoft.com/en-us/powershell/module/azurerm.sql/set-azurermsqldatabase?view=azurermps-6.13.0))
    ```powershell
        Set-AzureRmSqlDatabase -ResourceGroupName "ResourceGroup01"
        -DatabaseName "Database01" -ServerName "Server01"
        -Edition "Standard" -RequestedServiceObjectiveName "S2"

        Set-AzureRmSqlDatabase -ResourceGroupName "ResourceGroup01"
        -DatabaseName "Database01" -ServerName "Server01" 
        -ElasticPoolName "ElasticPool01"
    ```

- __Azure Resource Manager template export__ ([detail](https://azure.microsoft.com/en-us/blog/export-template/))
    - The __Export-AzureRmResourceGroup__ cmdlet captures the specified resource group as a template and saves it to a JSON file.This can be useful in scenarios where you have already created some resources in your resource group, and then want to leverage the benefits of using template backed deployments
        ```powershell
            Export-AzureRmResourceGroup -ResourceGroupName "TestGroup" 
        ```
        
        >__Export__ _cmdlet is capture change and save templete to a JSON file._

    - The __Save-AzureRmResourceGroupDeploymentTemplate__ cmdlet saves a resource group deployment template to a JSON file.

- __Log Analytics (KQL)__
```KQL
    Heartbeat
    | where TimeGenerated > ago(7d)
    | summmarize max(TimeGenerated) by Computer
    | where max_TimeGenerated < ago(1d)
```