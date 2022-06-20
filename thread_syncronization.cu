#include<thrust/device_vector.h>
//#include<thrust/host_vector.h>

#include<vector>
#include<cstdio>
#include<iostream>
#include<unistd.h>

using namespace std;

__global__ void explain_threads()
{
    printf("\nthreadId x: %d, y: %d, z: %d",threadIdx.x,threadIdx.y,threadIdx.z);
}

__global__ void explain_blocks()
{
    printf("\nblockId x: %d, y: %d, z: %d",blockIdx.x,blockIdx.y,blockIdx.z);
}

int main()
{
    dim3 thread_set(2,2,2);//no of instance run will be 2*2*2 here.threadIdx and blockIdx has 3 dimentions x,y,z.
    explain_threads<<<1,thread_set>>>();//<<<block_idx,thread_idx>>>
    explain_blocks<<<thread_set,1>>>();//<<<block_idx,thread_idx>>>
    //cudaThreadSynchronize();// deprecated version of cudaDeviceSynchronize
    cudaDeviceSynchronize();//halts execution in the CPU/host thread (that the cudaDeviceSynchronize was issued in) until the GPU has finished processing all previously requested cuda tasks (kernels, data copies, etc.)
    //cudaStreamSynchronize();//waits for the completion of onlt the streames provided as the parameters, for anything else done in gpu it do not wait
    sleep(1);

    return 0;
}