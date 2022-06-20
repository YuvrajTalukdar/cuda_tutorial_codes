#include<thrust/device_vector.h>
//#include<thrust/host_vector.h>

#include<vector>
#include<cstdio>
#include<iostream>

using namespace std;

struct data_struct2
{
    int id2;
    float number2;
    double number_double;
};

struct data_struct
{
    int id;
    float number;
    data_struct2 num_arr[5];//arrays inside vector allowed
    //vector<data_struct2> data_vec2;//vectors inside vectors not allowed as far as i know in cuda.
    //string name;//presence of string data used inside the kernel will result in compilation error
};

__global__ void kernel (data_struct* pd_vec)
{
    printf("blockIdx: %d id: %d number: %f\n", blockIdx.x, pd_vec[blockIdx.x].id,pd_vec[blockIdx.x].number);
    data_struct2* ds2=pd_vec[blockIdx.x].num_arr;
    printf("    threadIdx: %d id: %d number: %f number_double: %f\n",threadIdx.x,(ds2+threadIdx.x)->id2,(ds2+threadIdx.x)->number2,(ds2+threadIdx.x)->number_double);
}

int main()
{
    vector<data_struct> data_vector;
    for(int a=0;a<5;a++)
    {
        data_struct d1;
        d1.id=a;
        d1.number=8.965*(a+1);
        for(int b=0;b<5;b++)
        {
            d1.num_arr[b].id2=b;
            d1.num_arr[b].number2=b*10;
            d1.num_arr[b].number_double=b*45.3;
        }
        data_vector.push_back(d1);
    }
    

    thrust::device_vector<data_struct> d_vec = data_vector;
    data_struct* pd_vec = thrust::raw_pointer_cast(d_vec.data());

    int n = data_vector.size();
    int size_of_inner_array=5;
    kernel<<<size_of_inner_array, n>>>(pd_vec);//<<<block_idx,thread_idx>>>

    return 0;
}