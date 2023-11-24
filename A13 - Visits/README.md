## Visits, Throughput and Demands

Considering an embedded system composed by a CPU, a disk and a memory bank like in the following image:

 ![image1](https://github.com/simonescevaroli/performance-evaluation/assets/98689485/cca7b613-d322-4036-a84a-82a64d2e8cd6)
 
The disk controller can use DMA to transfer data between the memory and the disk independently from the CPU. New jobs start and finish on the CPU. 
The system is currently used by a fixed population of N = 10 users.

The following metrics were computed:
- The visits to the four stations
- The demand of the four stations

After testing has been completed, the fixed users are replaced by external arrival and departures. 
Moreover, it has been observed that sometimes the disk fails, making jobs leave immediately after their service. 
The new system can be modelled with the following queuing network:

![image2](https://github.com/simonescevaroli/performance-evaluation/assets/98689485/f4e526b2-763f-4b1d-a569-52cc75f6cc71)

Given this new scenario, the following metrics were computed:
- The visits to the three stations
- The demand of the three stations
- The throughput of the three stations
