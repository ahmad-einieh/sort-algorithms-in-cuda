// to run: nvcc oddEvenSortV2.cu -o bbb.out -gencode arch=compute_50,code=sm_50 

// ahmad einieh 
// 441106017

#include <stdio.h>
#include <cuda.h>

__global__ void oddEven(int* input_array, int* output_array, int size, int step) {

    int temp;
    int index = threadIdx.x + blockIdx.x * blockDim.x;
    if (index % 2 == step && index < size - 1) {
        if (input_array[index] > input_array[index + 1]) {
            temp = input_array[index];
            input_array[index] = input_array[index + 1];
            input_array[index + 1] = temp;
        }
    }
    __syncthreads();
    if (index < size) {
        output_array[index] = input_array[index];
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
    
    printf("Enter the unsorted numbers: (%d numbers)\n", n);
    int i;
    for (i = 0; i < n; i++)
    {
        scanf("%d", &array[i]);
    }

    cudaMalloc((void**) &device_array, size);
    cudaMalloc((void**) &device_array_sorted, size);

    cudaMemcpy(device_array,array,size,cudaMemcpyHostToDevice);

    int s;
    for (s = 1; s <= (n / 2); s++) {
        oddEven <<<1, n>>> ( device_array, device_array_sorted, n, 1);
        cudaThreadSynchronize();
        oddEven <<<1, n>>> (device_array_sorted, device_array, n, 0);
        cudaThreadSynchronize();
    }

    cudaMemcpy(array_sorted, device_array, size, cudaMemcpyDeviceToHost);

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
