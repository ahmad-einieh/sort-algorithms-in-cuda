// to run: nvcc bitonic.cu -o bitonic.out -gencode arch=compute_50,code=sm_50 

// ahmad einieh 
// 441106017

#include <stdio.h>
#include <cuda.h>
#include <math.h>


int ipow(int base,int exp);

__global__ void Bitoinc(int* input_array, int* output_array,int step,int stage, int size){
    int index = threadIdx.x + blockIdx.x * blockDim.x;
    int powerStepStage = ipow(2,stage+step);
    
    

}

int main(int argc, char** argv){

    //printf("%d",ipow(2,3));
    int *array, *array_sorted;
    int *device_array , *device_array_sorted;
    int n = 8; // we can change number of element in array
    int size = sizeof(int) * n;

    array = (int*) malloc(size);
    array_sorted = (int*) malloc(size);
    
    printf("Enter the unsorted numbers: (%d numbers)\n", n);
    for (int i = 0; i < n; i++)
    {
        scanf("%d", &array[i]);
    }

    cudaMalloc((void**) &device_array, size);
    cudaMalloc((void**) &device_array_sorted, size);

    cudaMemcpy(device_array,array,size,cudaMemcpyHostToDevice);

    int result = int(log2(n));

    for (int step = 0; step < n; step++)
    {
        for (int stage = 0; stage < step; stage++)
        {
            Bitoinc(device_array,device_array_sorted,step,stage,n);
        }
        
    }
    
    cudaMemcpy(array_sorted, device_array_sorted, size, cudaMemcpyDeviceToHost);

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

int ipow(int base, int exp)
{
    int result = 1;
    for (;;)
    {
        if (exp & 1)
            result *= base;
        exp >>= 1;
        if (!exp)
            break;
        base *= base;
    }

    return result;
}