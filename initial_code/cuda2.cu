#include<stdio.h>
#include<unistd.h>

__global__ void cuda_hello(){
    printf("Hello World from GPU!\n");
}

int main() {
    cuda_hello<<<2,3>>>(); 
    sleep(5);
    return 0;
}
