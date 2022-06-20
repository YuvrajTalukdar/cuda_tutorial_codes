#include<iostream>
#include<unistd.h>
#include<vector>

using namespace std;

struct data_struct
{
    int id;
    float number;
    string name;
};

__global__ void print_data(data_struct *data)
{
    printf("ID: %d",data->id);
    printf("\nnumber: %f",data->number);
    //printf("\nname: %s",data->name);//std::string not supported in cuda functions
}

int main()
{
    //alocating structure obj
    data_struct d1;
    d1.id=145;
    d1.name="Yuvraj Talukdar";
    d1.number=478.365;
    data_struct *d1_g;
    cudaMalloc((void**)&d1_g,sizeof(data_struct));
    cudaMemcpy(d1_g,&d1,sizeof(data_struct),cudaMemcpyHostToDevice);
    print_data<<<1,1>>>(d1_g);

    sleep(3);
    return 0;
}