#include<iostream>
#include"cuda_code.cuh"

using namespace std;

class cuda_launcher
{
    int id;
    public:
    void launch_cuda()
    {
        start_kernels();
    }
};

int main()
{
    cuda_launcher cl;    
    cl.launch_cuda();

    return 0;
}

