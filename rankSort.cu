// to run: nvcc rankSort.cu -o rankSort.out -gencode arch=compute_50,code=sm_50 

// ahmad einieh 
// 441106017

#include <stdio.h>
#include <cuda.h>
#include <random>

__global__ void ranksort(int* input_array, int* output_array, int size){
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < size) { 
    int x = 0; 
    /* count number less than it */ 
    for (int j = 0; j < size; j++) {
    if (input_array[i] > input_array[j]) 
        x++; 
    if(input_array[i] == input_array[j] && j < i) 
        x++;
    }
    
    /* copy no. into correct place */ 
    output_array[x] = input_array[i]; 
    } 
} 

int main()
{
    int *array, *array_sorted;
    int *device_array , *device_array_sorted;
    int n = 8; // we can change number of element in array
    int size = sizeof(int) * n;

    array = (int*) malloc(size);
    array_sorted = (int*) malloc(size);
    
    //printf("Enter the unsorted numbers: (%d numbers)\n", n);
    int i;
    for (i = 0; i < n; i++)
    {
        array[i] =rand()%9;
        //scanf("%d", &array[i]);
    }
    
    int w;
    for (w= 0; w < n; w++) {
        printf("%d\t", array[w]);
    }
    printf("\n");


    cudaMalloc((void**) &device_array, size);
    cudaMalloc((void**) &device_array_sorted, size);

    cudaMemcpy(device_array,array,size,cudaMemcpyHostToDevice);

    ranksort<<<n,n>>>(device_array,device_array_sorted,n);

    cudaMemcpy(array_sorted, device_array_sorted, size, cudaMemcpyDeviceToHost);

    int k;
    for (k= 0; k < n; k++) {
        printf("%d\t",array_sorted[k]);
    }

    printf("\n");

    free(array);
    free(array_sorted);
    cudaFree(device_array_sorted);
    cudaFree(device_array);

    return 0;
}
