// to run: nvcc bitonic.cu -gencode arch=compute_50,code=sm_50 

// ahmad einieh 
// 441106017

#include <stdio.h>
#include <cuda.h>
#include <math.h>


__device__ __host__ int ipow(int base,int exp);

__global__ void Bitoinc(int* input_array, int* output_array,int step,int stage, int size){

    int index = threadIdx.x + blockIdx.x * blockDim.x;
    int N = ipow(2, step) / ipow(2, stage - 1);
    int shift = N / 2;
    char working = (index % N) < shift;
    char ascending = (index / ipow(2, step)) % 2 == 0;

    if (index < size && working)
    {
    if(ascending){
        if (input_array[index]>input_array[index+shift])
        {
            int temp = input_array[index];
            input_array[index]= input_array[index+shift];
            input_array[index+shift] = temp;
        }   
    }else{
        if (input_array[index]<input_array[index+shift])
        {
            int temp = input_array[index];
            input_array[index]= input_array[index+shift];
            input_array[index+shift] = temp;
        }   
    }
    }

}

int main(int argc, char** argv){

    int *array, *array_sorted;
    int *device_array , *device_array_sorted;
    int n = 16; // we can change number of element in array
    int size = sizeof(int) * n;

    array = (int*) malloc(size);
    array_sorted = (int*) malloc(size);
    
    for (int i = 0; i < n; i++)
    {
        array[i] =rand();
    }
    printf("\n");
    for (int k= 0; k < n; k++) {
        printf("%d\t",array[k]);
    }
    printf("\n");
    cudaMalloc((void**) &device_array, size);
    cudaMalloc((void**) &device_array_sorted, size);

    cudaMemcpy(device_array,array,size,cudaMemcpyHostToDevice);

    int result = ceil(log2(n));

    for (int step = 1; step <= result; step++)
    {
        for (int stage = 1; stage <= step; stage++)
        {
            Bitoinc<<<n,n>>>(device_array,device_array_sorted,step,stage,n);
        }
        
    }
    
    cudaMemcpy(array_sorted, device_array, size, cudaMemcpyDeviceToHost);

    for (int k= 0; k < n; k++) {
        printf("%d\t",array_sorted[k]);
    }

    printf("\n");

    free(array);
    free(array_sorted);
    cudaFree(device_array_sorted);
    cudaFree(device_array);

    return 0;
}

__device__ __host__ int ipow(int base, int exp)
{
    int result = 1;
    while (exp){
        if (exp % 2)
           result *= base;
        exp /= 2;
        base *= base;
    }
    return result;
}