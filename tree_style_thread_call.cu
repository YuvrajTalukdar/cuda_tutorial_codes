//use -arch=sm_86 or sm_80 for ampear architecture
//-rdc=true is required here
#include<cstdio>
#include<iostream>
#include<unistd.h>

using namespace std;

int host_fx()//__host__ is called only from host
{
    printf("\nCalled from host fx\n");
    return 5;
}

__device__ void fx2()
{
    printf("\ncall from fx2");
}

__device__ void fx()//__device__ this acts as a normal function called from the kernel
{
    printf("\nfunction1 x: %d, y: %d, z: %d",threadIdx.x,threadIdx.y,threadIdx.z);
    fx2();
}

__global__ void kernel2(bool kernel_call)//__global__  this is the kernel function, only kernel functions can be called in multi threaded mode
{
    if(!kernel_call)
    {   printf("\nkernel2 x: %d, y: %d, z: %d",threadIdx.x,threadIdx.y,threadIdx.z);}
    else
    {   printf("\nkernel2 x: %d, y: %d, z: %d",threadIdx.x,threadIdx.y,threadIdx.z);}
}

__global__ void kernel1(bool kernel_call)
{
    printf("\nkernel1 x: %d, y: %d, z: %d",threadIdx.x,threadIdx.y,threadIdx.z);
    dim3 thread_group(1,1,2);
    if(!kernel_call)
    {   fx();}
    else
    {   kernel2<<<1,thread_group>>>(kernel_call);}
}

int main()
{
    dim3 thread_set(8,1,1);//no of instance run will be 2*2*2 here
    kernel1<<<1,thread_set>>>(false);//<<<block_idx,thread_idx>>>
    kernel1<<<1,2>>>(true);//<<<block_idx,thread_idx>>>
    cudaDeviceSynchronize();//halts execution in the CPU/host thread (that the cudaDeviceSynchronize was issued in) until the GPU has finished processing all previously requested cuda tasks (kernels, data copies, etc.)
    cout<<"\nr= "<<host_fx();
    //cudaStreamSynchronize();//waits for the completion of onlt the streames provided as the parameters, for anything else done in gpu it do not wait
    //sleep(1);

    return 0;
}