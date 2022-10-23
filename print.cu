// nvcc print.cu -gencode arch=compute_50,code=sm_50 
#include <stdio.h>

__global__ void print() { printf("Hello World!"); }

int main() { print<<<1,4>>>(); cudaDeviceSynchronize(); }