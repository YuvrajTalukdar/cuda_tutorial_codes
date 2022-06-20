#include<iostream>

using namespace std;

__global__ void thread_memory_analysis()
{
    int auto_var=1;//auro var. Stored in registers, and if size grows moved to local memory, accessible only by current thread
    __shared__ int shared_var;//shared var. Stored in shared memory, accessible from all threads in its block.
    if(threadIdx.x==0)
    {   
        auto_var=auto_var+5;
        shared_var=5;
        printf("\nauto_var: %d shared_var: %d threadIdx: %d",auto_var,shared_var,threadIdx.x);
    }
    else
    {   
        shared_var+=threadIdx.x;
        printf("\nauto_var: %d shared_var: %d threadIdx: %d",auto_var,shared_var,threadIdx.x);
    }
}
//it looks like data to be allocated to gpu vram, we need to use traditional memory allocation and data copy.
__global__ void block_memory_analysis()
{
    int auto_var=1;//auto var. Stored in registers, accessible only by current thread
    __shared__ int shared_var;//shared var. Stored in shared memory, accessible from all threads in its block.
    if(blockIdx.x==0)
    {   
        auto_var=auto_var+8;
        printf("\nauto_var: %d shared_var: %d blockIdx: %d",auto_var,shared_var,blockIdx.x);
    }
    else
    {   shared_var+=blockIdx.x;
        printf("\nauto_var: %d shared_var: %d blockIdx: %d",auto_var,shared_var,blockIdx.x);}
} 

int main()
{
    thread_memory_analysis<<<1,10>>>();//<<<block_idx,thread_idx>>>
    block_memory_analysis<<<10,1>>>();
    cudaDeviceSynchronize();
    return 0;
}