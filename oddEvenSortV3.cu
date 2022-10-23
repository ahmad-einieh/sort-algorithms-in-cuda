// to run: nvcc oddEvenSortV3.cu -o aaa.out -gencode arch=compute_50,code=sm_50 

// ahmad einieh 
// 441106017

#include <stdio.h>
#include <cuda.h>

__global__ void oddEvenSort(int *in, int *out, int size)
{

    __shared__ bool swappedodd;
    __shared__ bool swappedeven;

    int temp;
    bool IsOdd = true;
    int index = threadIdx.x + blockIdx.x * blockDim.x;

    while (1)
    {
        __syncthreads();
        if (IsOdd == true)
        {
            swappedodd = false;
            __syncthreads();

            if (index % 2 == 1 && index < size - 1)
            {
                if (in[index] > in[index + 1])
                {
                    temp = in[index];
                    in[index] = in[index + 1];
                    in[index + 1] = temp;
                    swappedodd = true;
                }
            }
        }
        else
        {
            swappedeven = false;
            __syncthreads();

            if (index % 2 == 0 && index < size - 1)
            {
                if (in[index] > in[index + 1])
                {
                    temp = in[index];
                    in[index] = in[index + 1];
                    in[index + 1] = temp;
                    swappedeven = true;
                }
            }
        }

        __syncthreads();
        if (!(swappedodd || swappedeven))
            break;

        IsOdd = !IsOdd;
    }

    __syncthreads();

    if (index < size)
        out[index] = in[index];
}

int main(void)
{
    int i;
    int *array, *array_sorted;
    int *device_array, *device_array_sorted;
    int n = 8; // we can change number of element in array
    int size = sizeof(int) * n;

    cudaMalloc((void **)&device_array, size);
    cudaMalloc((void **)&device_array_sorted, size);

    array = (int *)malloc(size);
    array_sorted = (int *)malloc(size);

    printf("Enter the unsorted numbers: (%d numbers)\n", n);

    for (i = 0; i < n; i++)
    {
        scanf("%d", &array[i]);
    }

    cudaMemcpy(device_array, array, size, cudaMemcpyHostToDevice);

    oddEvenSort<<<1, n>>>(device_array, device_array_sorted, n);

    cudaMemcpy(array_sorted, device_array_sorted, size, cudaMemcpyDeviceToHost);

    for (i = 0; i < n; i++)
    {
        printf("%d\t", array_sorted[i]);
    }

    printf("\n");

    free(array);
    free(array_sorted);
    cudaFree(device_array_sorted);
    cudaFree(device_array);
}