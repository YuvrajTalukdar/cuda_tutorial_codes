#include<thrust/device_vector.h>
#include<vector>
#include<cstdio>
#include<iostream>

using namespace std;

struct data_struct
{
    int id;
    float number;
    //string name;//presence of string data used inside the kernel will result in compilation error
};

__global__ void kernel (data_struct* pd_vec, int n)
{
    if(threadIdx.x < n)
    {   printf("threadIdx: %d id: %d number: %f\n", threadIdx.x, pd_vec[threadIdx.x].id,pd_vec[threadIdx.x].number);}
}

int main()
{
    vector<data_struct> data_vector;
    for(int a=0;a<10;a++)
    {
        data_struct d1;
        d1.id=a;
        d1.number=8.965*(a+1);
        data_vector.push_back(d1);
    }
    //{

    thrust::device_vector<data_struct> d_vec = data_vector;
    data_struct* pd_vec = thrust::raw_pointer_cast(d_vec.data());

    int n = data_vector.size();
    kernel<<<1, n>>>(pd_vec, n);//<<<block_idx,thread_idx>>>
    //cudaDeviceSynchronize();//Wait for compute device to finish. If kernel calls are considered as thread calls, than cudaDeviceSynchronize is like the join function.
    //}
    //cudaDeviceReset();//Destroy all allocations and reset all state on the current device in the current process.

    return 0;
}