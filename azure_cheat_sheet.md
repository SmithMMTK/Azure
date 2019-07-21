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