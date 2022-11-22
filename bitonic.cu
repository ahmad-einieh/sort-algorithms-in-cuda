// to run: nvcc bitonic.cu -o bitonic -gencode arch=compute_50,code=sm_50 

// ahmad einieh 
// 441106017

#include <stdio.h>
#include <cuda.h>
#include <math.h>

//power function for int
__device__ int intPower(int base, int exp)
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

// device function for bitonic sort
__global__ void Bitoinc(int* input_array,int step,int stage, int size){

    int index = threadIdx.x + blockIdx.x * blockDim.x;
    int N = intPower(2, step) / intPower(2, stage - 1);
    int shift = N / 2;

    //check if the index is in the range of the array
    if (index < size &&  (index % N) < shift)
    {
        // check if ascending or descending part
    if((index / intPower(2, step)) % 2 == 0){
        if (input_array[index]>input_array[index+shift])
        {
            // switch between elements
            int temp = input_array[index];
            input_array[index]= input_array[index+shift];
            input_array[index+shift] = temp;
        }   
    }else{
        if (input_array[index]<input_array[index+shift])
        {
            // switch between elements
            int temp = input_array[index];
            input_array[index]= input_array[index+shift];
            input_array[index+shift] = temp;
        }   
    }
    }

}

int main(int argc, char** argv){

    int *array, *array_sorted;
    int *device_array;
    // size of elements in array
    int n = 32; // we can change number of element in array
    int size = sizeof(int) * n;

    // allocate memory for array
    array = (int*) malloc(size);
    array_sorted = (int*) malloc(size);
    // add element to array by random value
    for (int i = 0; i < n; i++)
    {
        array[i] =rand();
    }
    // print unsorted array
    printf("\nnot sorted array:\n");
    for (int k= 0; k < n; k++) {
        printf("%d\t",array[k]);
    }
    printf("\n");

    // allocate memory for device array
    cudaMalloc((void**) &device_array, size);
    // copy element from CPU array to GPU array
    cudaMemcpy(device_array,array,size,cudaMemcpyHostToDevice);

    // how many time will loop will run
    int result = ceil(log2(n));
    // loop for bitonic sort
    for (int step = 1; step <= result; step++)
    {
        for (int stage = 1; stage <= step; stage++)
        {
            // call bitonic funcition from device
            Bitoinc<<<n,n>>>(device_array,step,stage,n);
        }
        
    }
    // copy element from GPU array to CPU array
    cudaMemcpy(array_sorted, device_array, size, cudaMemcpyDeviceToHost);

    // print sorted array
    printf("\nsorted array:\n");
    for (int k= 0; k < n; k++) {
        printf("%d\t",array_sorted[k]);
    }
    printf("\n");

    // free spaces for all things
    free(array);
    free(array_sorted);
    cudaFree(device_array);

    return 0;
}
