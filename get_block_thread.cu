/*
This program gets the following details:-
1. No of gpu
2. GPU Name
3. No of blocks
4. No of threads per blocks
5. Total grobal vram
6. Total Shared Memory
*/
#include<iostream>

using namespace std;

int main()
{
    int nDevices;
    cudaGetDeviceCount(&nDevices);
    cout<<"Number of devices: "<<nDevices;
    for(int a=0;a<nDevices;a++)
    {
        cout<<"\nDevice ID: "<<a;
        cudaDeviceProp prop;
        cudaGetDeviceProperties(&prop, a);
        cout<<"\nDevice Name: "<<prop.name;
        cout<<"\nNo of blocks: "<<prop.maxBlocksPerMultiProcessor;
        cout<<"\nNo of thread per Blocks: "<<prop.maxThreadsPerBlock;
        cout<<"\nTotal Global Memory in MB: "<<(float)prop.totalGlobalMem/((float)1024*1024);//vram 
        cout<<"\nTotal Shared Memory in KB: "<<(float)(prop.sharedMemPerBlock)/1024.0;//accessible by the block which owns it. Its like the personal cache for the block.
    }

    return 0;
}