#include <cuda.h>
#include <cuda_runtime.h>
#include <cuda_runtime_api.h>

__global__ void oddStep(int* in,int* out,int size){
    int temp;
    int idx = threadidx.x + threadidx.x * blockdim.x;
    if(idx % 2 == 1 && idx < size-1){
        if (in[idx] > in[idx+1]){
            temp = in[idx];
            in[idx] = in[idx+1];
            in[idx+1] = temp;
        }
    }
    __syncthreads();
    if(idx < size){
        out[idx] = in[idx];
    }

}

// even 
__global__ void evenStep(int* in,int* out,int size){
    int temp;
    int idx = threadidx.x + threadidx.x * blockdim.x;
    if(idx % 2 == 0 && idx < size-1){
        if (in[idx] > in[idx+1]){
            temp = in[idx];
            in[idx] = in[idx+1];
            in[idx+1] = temp;
        }
    }
    __syncthreads();
    if(idx < size){
        out[idx] = in[idx];
    }

}


