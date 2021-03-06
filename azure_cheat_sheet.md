__Understand VM instance size__ ([detail](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/tutorial-create-and-manage-cli#vm-instance-sizes))

Type | Common sizes	| Description
--- | --- | ---
General purpose	 | Dsv3, Dv3, DSv2, Dv2, DS, D, Av2, A0-7 | Balanced CPU-to-memory. Ideal for dev / test and small to medium applications and data solutions.
Compute optimized | Fs, F | High CPU-to-memory. Good for medium traffic applications, network appliances, and batch processes.
Memory optimized | Esv3, Ev3, M, GS, G, DSv2, DS, Dv2, D | High memory-to-core. Great for relational databases, medium to large caches, and in-memory analytics.
Storage optimized | Ls | High disk throughput and IO. Ideal for Big Data, SQL, and NoSQL databases.
GPU | NV, NC | Specialized VMs targeted for heavy graphic rendering and video editing.
High performance | H, A8-11 | Our most powerful CPU VMs with optional high-throughput network interfaces (RDMA). 
---

__High Availability Options__

Option | SLA
--- | ---
Single VM | 99.9%
Availability set | 99.95%
Availability Zone | 99.99%

---

SLA | Downtime per week | Downtime per month | Downtime per year
--- | --- | --- | ---
99% | 1.68 hours | 7.2 hours |3.65 days
99.9% | 10.1 minutes | 43.2 minutes | 8.76 hours
99.95% | 5 minutes | 21.6 minutes | 4.38 hours
99.99% | 1.01 minutes | 4.32 minutes | 52.56 minutes
99.999% |  6 seconds | 25.9 seconds | 5.26 minutes

---
__Azure messaging services__ ([detail](https://docs.microsoft.com/en-us/azure/event-grid/compare-messaging-services))

Azure offers three services that assist with delivering event messages throughout a solution. These services are:

- [Event Grid](https://docs.microsoft.com/en-us/azure/event-grid/)
- [Event Hubs](https://docs.microsoft.com/en-us/azure/event-hubs/)
- [Service Bus](https://docs.microsoft.com/en-us/azure/service-bus-messaging/)

---

__Decision tree for Azure compute services__

![alt text](https://docs.microsoft.com/en-us/azure/architecture/guide/images/compute-decision-tree.svg)

[more...](https://docs.microsoft.com/en-us/azure/architecture/guide/technology-choices/compute-decision-tree)

---

__Replication Option Comparison__

Replication	| Copies | Strategy
--- | --- | ---
Locally redundant storage (LRS)	| Maintains three copies of your data.	|Data is replicated three time within a single facility in a single region.
Zone-redundant storage (ZRS)    | 	Maintains three copies of your data.	| Data is replicated three times across two to three facilities, either within a single region or across two regions.
Geo-redundant storage (GRS)	| Maintains six copies of your data.	 |Data is replicated three times within the primary region and is also replicated three times in a secondary region hundreds of miles away from the primary region.
Read access geo-redundant storage (RA-GRS) | Maintains six copies of your data. | Data is replicated to a secondary geographic location and provides read access to your data in the secondary location.


Replication Option  |	LRS   | ZRS   |   GRS |   RA-GRS
--- | --- | --- | --- | ---
Node unavailability within a data center | Yes | Yes | Yes | Yes
An entire data center (zonal or non-zonal) becomes unavailable | No | Yes | Yes | Yes
A region-wide outage | No | No | Yes | Yes
Read access to your data (in a remote, geo-replicated region) in the event of region-wide unavailability | No | No | No | Yes
Available in storage account types | GPv1, GPv2, Blob | Standard, GPv2 | GPv1, GPv2, Blob | GPv1, GPv2, Blob
[( More ... )](https://docs.microsoft.com/en-us/azure/storage/common/storage-redundancy-grs)

---

__Comparison of services__

| __Service__ | __Purpose__ | __Type__ | __When to use__ |
|---|---|---|---|
| Event Grid | Reactive programming | Event distribution (discrete) | React to status changes |
| Event Hubs | Big data pipeline | Event streaming (series) | Telemetry and distributed data streaming |
| Service Bus | High-value enterprise messaging | Message | Order processing and financial transactions |

---

__Comparison between Functions vs. WebJobs__

. | Functions | WebJobs
--- | --- | ---
Serverless app model with automatic scaling	| Supported | 
Develop and test in browser	| Supported | 
Pay-per-use pricing	| Supported | 
Integration with Logic Apps	| Supported | 
Trigger events | Timer, Azure Storage queues and blobs, Azure Service Bus queues and topics, Azure Cosmos DB, Azure Event Hubs, HTTP/WebHook (GitHub, Slack), Azure Event Grid | Timer, Azure Storage queues and blobs, Azure Service Bus queues and topics, Azure Cosmos DB, Azure Event Hubs, File system
Supported languages | C#, F#, JavaScript, Java (preview), Pytho (preview) | C#
Package managers | NPM and NuGet | NuGet

---

__Mixing Authentication__

Authentication Method	| Usage
--- | ---
Password	| MFA and SSPR
Security questions	| SSPR Only
Email address	|SSPR Only
Microsoft Authenticator app	| MFA and public preview for SSPR
OATH Hardware token	| Public preview for MFA and SSPR
SMS	|MFA and SSPR
Voice call	|MFA and SSPR
App passwords	|MFA only in certain cases


---

__Role Definition and Built-in Roles__

- [Role Definition and Description](https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/directory-assign-admin-roles#available-roles)
	
- [Least-privileged roles by task](https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/roles-delegate-by-task)
	
- [Built-In Roles](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles)


---

__Express Route Location__

[Location](https://docs.microsoft.com/en-us/azure/expressroute/expressroute-locations#locations)

Geopolitical region	| Azure regions	| ExpressRoute locations
---|---|---
Australia Government	| Australia Central, Australia Central 2	| Canberra, Canberra2
Europe	| France Central, France South, North Europe, West Europe, UK West, UK South	| Amsterdam, Amsterdam2, Copenhagen, Dublin, Frankfurt, London, London2, Marseille, Newport(Wales), Paris, Stockholm, Zurich
North America	| East US, West US, East US 2, West US 2, Central US, South Central US, North Central US, West Central US, Canada Central, Canada East	| Atlanta, Chicago, Dallas, Denver, Las Vegas, Los Angeles, Miami, New York, San Antonio, Seattle, Silicon Valley, Silicon Valley2, Washington DC, Washington DC2, Montreal, Quebec City, Toronto
Asia	| East Asia, Southeast Asia	| Hong Kong SAR, Kuala Lumpur, Singapore, Singapore2, Taipei
India	| India West, India Central, India South	| Chennai, Chennai2, Mumbai, Mumbai2
Japan	| Japan West, Japan East	| Osaka, Tokyo
Oceania	| Australia Southeast, Australia East	| Auckland, Melbourne, Perth, Sydney
South Korea	| Korea Central, Korea South	| Busan, Seoul
UAE	| UAE Central, UAE North	| Dubai, Dubai2
South Africa	| South Africa West, South Africa North	| Cape Town, Johannesburg
South America	| Brazil South	| Sao Paulo

---
