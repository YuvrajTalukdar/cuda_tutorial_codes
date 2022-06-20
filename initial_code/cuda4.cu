//testing async compute
#include<stdio.h>
#include<unistd.h>
#include<iostream>
#include<chrono>
#include<random>
#include"cuda_runtime_api.h"
#include"cuda.h"
#include"cuda_runtime.h"

using namespace std;
using namespace chrono;

__global__ void infinite_loop()
{
    int x=0;
    while(true)
    {
        x++;x--;
    }
}

int getSPcores(cudaDeviceProp devProp)
{  
    int cores = 0;
    int mp = devProp.multiProcessorCount;
    switch (devProp.major){
     case 2: // Fermi
      if (devProp.minor == 1) cores = mp * 48;
      else cores = mp * 32;
      break;
     case 3: // Kepler
      cores = mp * 192;
      break;
     case 5: // Maxwell
      cores = mp * 128;
      break;
     case 6: // Pascal
      if ((devProp.minor == 1) || (devProp.minor == 2)) cores = mp * 128;
      else if (devProp.minor == 0) cores = mp * 64;
      else printf("Unknown device type\n");
      break;
     case 7: // Volta and Turing
      if ((devProp.minor == 0) || (devProp.minor == 5)) cores = mp * 64;
      else printf("Unknown device type\n");
      break;
     case 8: // Ampere
      if (devProp.minor == 0) cores = mp * 64;
      else if (devProp.minor == 6) cores = mp * 128;
      else printf("Unknown device type\n");
      break;
     default:
      printf("Unknown device type\n"); 
      break;
      }
    return cores;
}

void print_device_props() 
{
    int nDevices;
    cudaGetDeviceCount(&nDevices);
    printf("Number of devices: %d\n", nDevices);
    for (int i = 0; i < nDevices; i++) 
    {
        cudaDeviceProp prop;
        cudaGetDeviceProperties(&prop, i);
        printf("Device Number: %d\n", i);
        printf("  Device name: %s\n", prop.name);
        printf("  Memory Clock Rate (MHz): %d\n",
                prop.memoryClockRate/1024);
        printf("  Memory Bus Width (bits): %d\n",
                prop.memoryBusWidth);
        printf("  Peak Memory Bandwidth (GB/s): %.1f\n",
                2.0*prop.memoryClockRate*(prop.memoryBusWidth/8)/1.0e6);
        printf("  Total global memory (Gbytes) %.1f\n",(float)(prop.totalGlobalMem)/1024.0/1024.0/1024.0);
        printf("  Shared memory per block (Kbytes) %.1f\n",(float)(prop.sharedMemPerBlock)/1024.0);
        printf("  minor-major: %d-%d\n", prop.minor, prop.major);
        printf("  Warp-size: %d\n", prop.warpSize);
        printf("  Concurrent kernels: %s\n", prop.concurrentKernels ? "yes" : "no");
        printf("  Concurrent computation/communication: %s\n\n",prop.deviceOverlap ? "yes" : "no");
    }
}

int main()
{
    //infinite_loop<<<10,5>>>();
    int deviceID;
    cudaDeviceProp props;
    cudaGetDevice(&deviceID);
    cudaGetDeviceProperties(&props,deviceID);
    int CUDACores = getSPcores(props);
    cout<<"Cores: "<<CUDACores;
    cout<<"\nMultiprocessor Count: "<<props.multiProcessorCount;
    cout<<"\nAsync Engine Count: "<<props.asyncEngineCount;
    print_device_props();
    return 0;
}