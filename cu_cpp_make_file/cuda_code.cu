#include<stdio.h>

__global__ void explain_threads()
{
    printf("\nthreadId x: %d, y: %d, z: %d",threadIdx.x,threadIdx.y,threadIdx.z);
}

__global__ void explain_blocks()
{
    printf("\nblockId x: %d, y: %d, z: %d",blockIdx.x,blockIdx.y,blockIdx.z);
}

void start_kernels()
{
    dim3 thread_set(2,2,2);//no of instance run will be 2*2*2 here.threadIdx and blockIdx has 3 dimentions x,y,z.
    explain_threads<<<1,thread_set>>>();//<<<block_idx,thread_idx>>>
    explain_blocks<<<thread_set,1>>>();//<<<block_idx,thread_idx>>>

    cudaDeviceSynchronize();
}