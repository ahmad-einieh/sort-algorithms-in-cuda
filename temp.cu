#include <stdio.h>

__global__ void count3(int *a,int* result)  { 
    int id = threadIdx.x;
    
    if (a[id] == 3) {
        result[id] = 1;
    }
    else{
        result[id] = 0;
    }
}

int main() { 
    int n = 8;
    int *a;
    int *d_a;
    int size = n * sizeof(int);
    a = (int *)malloc(size);
    cudaMalloc((void **)&d_a, size);

    a[0] = 3;
    a[1] = 2;
    a[2] = 3;
    a[3] = 4;
    a[4] = 3;
    a[5] = 3;
    a[6] = 7;
    a[7] = 3;
    
    int *b;
    int *d_b;
    b = (int *)malloc(size);
    cudaMalloc((void **)&d_b, size);

    cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);

    count3<<<1, n>>>(d_a,d_b);

    cudaDeviceSynchronize();
    cudaMemcpy(b, d_b,size, cudaMemcpyDeviceToHost);

    int count = 0;
    for (int i = 0; i < n; i++)
    {
        count = count + b[i];
    }
    

    printf("\n%d\n", count);
    return 0;
}