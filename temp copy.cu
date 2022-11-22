// nvcc temp.cu -o temp -gencode arch=compute_50,code=sm_50 
#include <stdio.h>

__global__ void count3(int *a,int* result)  { 
    int id = threadIdx.x;
    //int count = 0;
     //printf("%d\n",a[id]);
    if (a[id] == 3) {
        //count++; 
        *result = *result +  1;
 }
    
    // __syncthreads();
    // printf("%d -",count);
    //*result = *result +  count;
 }

int main() { 
    int n = 8;
    int *a;
    int *d_a;
    int size = n * sizeof(int);
    a = (int *)malloc(size);
    cudaMalloc((void **)&d_a, size);
    for ( int i = 0; i < n; i++)
    {
        a[i] = i;
        //printf("%d - ", a[i]);
    }
    // printf("\n");
    
    int b = 0;
    int *d_b;
    cudaMalloc((void **)&d_b, sizeof(int));

    cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, &b, sizeof(int), cudaMemcpyHostToDevice);

    count3<<<1, n>>>(d_a,d_b);

    cudaDeviceSynchronize();
    cudaMemcpy(&b, d_b, sizeof(int), cudaMemcpyDeviceToHost);

    printf("\n%d\n", b);
    return 0;
}