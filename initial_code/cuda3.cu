//adding 2 arrays in cuda
#include<stdio.h>
#include<unistd.h>
#include<iostream>
#include<chrono>
#include<random>

using namespace std;
using namespace chrono;

__global__ void add_by_gpu(int *x,int *y,int *result)
{
    result[blockIdx.x]=x[blockIdx.x]+y[blockIdx.x];
}

__global__ void hello()
{
    printf("\nhello world from gpu\n");
}

int get_random_number(int min,int max)
{
    random_device dev;
    mt19937 rng(dev());
    uniform_int_distribution<std::mt19937::result_type> dist6(min,max); // distribution in range [1, 6]
    return dist6(rng);
}

int main() 
{
    auto point0_1 = high_resolution_clock::now();
    hello<<<1,1>>>();
    auto point0_2 = high_resolution_clock::now();
    auto duration0 = duration_cast<microseconds>(point0_2 - point0_1);
    cout<<"Time required to print hello world by gpu: "<<to_string(duration0.count()/pow(10,6))<<endl;

    auto point1 = high_resolution_clock::now();
    int size=10000;
    int data_size=sizeof(int)*size;
    int x[size],y[size],*result=(int*)malloc(data_size);
    int *x_d,*y_d,*result_d;
    for(int a=0;a<size;a++)
    {
        x[a]=get_random_number(1,size);
        y[a]=get_random_number(1,size);
    }
    auto point2 = high_resolution_clock::now();
    auto duration1 = duration_cast<microseconds>(point2 - point1);
    cout<<"Time required to initialize the arrays(cpu): "<<to_string(duration1.count()/pow(10,6));
    
    auto point3 = high_resolution_clock::now();
    cudaMalloc((void **)&x_d,data_size);
    auto point3_2 = high_resolution_clock::now();
    cudaMalloc((void **)&y_d,data_size);
    auto point3_3 = high_resolution_clock::now();
    cudaMalloc((void **)&result_d,data_size);
    auto point4 = high_resolution_clock::now();
    auto duration2 = duration_cast<microseconds>(point4 - point3);
    cout<<"\nTime required to allocate "<<data_size<<"*3 in gpu : "<<to_string(duration2.count()/pow(10,6));
    auto duration2_2 = duration_cast<microseconds>(point3_2 - point3);
    cout<<"\nTime required to allocate "<<data_size<<"*1 in gpu : "<<to_string(duration2_2.count()/pow(10,6));
    auto duration2_3 = duration_cast<microseconds>(point3_3 - point3_2);
    cout<<"\nTime required to allocate "<<data_size<<"*1 in gpu : "<<to_string(duration2_3.count()/pow(10,6));
    auto duration2_4 = duration_cast<microseconds>(point4 - point3_3);
    cout<<"\nTime required to allocate "<<data_size<<"*1 in gpu : "<<to_string(duration2_4.count()/pow(10,6));

    auto point5 = high_resolution_clock::now();
    cudaMemcpy(x_d,&x,data_size,cudaMemcpyHostToDevice);
    auto point5_2 = high_resolution_clock::now();
    cudaMemcpy(y_d,&y,data_size,cudaMemcpyHostToDevice);
    auto point6 = high_resolution_clock::now();
    auto duration3 = duration_cast<microseconds>(point6-point5);
    cout<<"\nTime required to copy "<<data_size<<"*2 to gpu : "<<to_string(duration3.count()/pow(10,6));
    auto duration3_2 = duration_cast<microseconds>(point5_2 - point5);
    cout<<"\nTime required to copy "<<data_size<<"*1 to gpu : "<<to_string(duration3_2.count()/pow(10,6));
    auto duration3_3 = duration_cast<microseconds>(point6 - point5_2);
    cout<<"\nTime required to copy "<<data_size<<"*1 to gpu : "<<to_string(duration3_3.count()/pow(10,6));

    auto point7 = high_resolution_clock::now();
    add_by_gpu<<<size,1>>>(x_d,y_d,result_d);
    auto point8 = high_resolution_clock::now();
    auto duration4 = duration_cast<microseconds>(point8-point7);
    cout<<"\nTime required to complete the addition by gpu : "<<to_string(duration4.count()/pow(10,6));

    auto point9 = high_resolution_clock::now();
    cudaMemcpy(result,result_d,data_size,cudaMemcpyDeviceToHost);
    cudaFree(x_d);
	cudaFree(y_d);
    cudaFree(result_d);
    auto point10 = high_resolution_clock::now();
    auto duration5 = duration_cast<microseconds>(point10-point9);
    cout<<"\nTime required to copy the results to host and free the vram : "<<to_string(duration5.count()/pow(10,6));

    cout<<"\n\n";
    bool ok=true;
    for(int a=0;a<size;a++)
    {
        //cout<<"\nx="<<x[a]<<" y="<<y[a]<<" r="<<*(result+a);
        if(x[a]+y[a]!=*(result+a))
        {   ok=false;break;}
    } 
    if(ok)
    {   cout<<"\nAddition done correctly.";}
    else
    {   cout<<"\nAddition could not be done correctly.";}
    //sleep(5);
    return 0;
}
