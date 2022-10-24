#include <stdio.h>
#include <cuda.h>

int main(int argc, char const *argv[])
{
    int count;
    cudaDeviceProp prop;

    cudaGetDeviceCount(&count);
    printf("Device count: %d", count);
    for (int i = 0; i < count; i++)
    {
        cudaGetDeviceProperties(&prop, i);
        printf("\nDevice name: %s", prop.name);
        printf("\nDevice compute capability: %d.%d", prop.major, prop.minor);
        printf("\nDevice clock rate: %d", prop.clockRate);
        printf("\nDevice memory clock rate: %d", prop.memoryClockRate);
        printf("\nDevice memory bus width: %d", prop.memoryBusWidth);
        printf("\nDevice warp size: %d", prop.warpSize);
        printf("\nDevice max threads per block: %d", prop.maxThreadsPerBlock);
        printf("\nDevice max threads dim: %d %d %d", prop.maxThreadsDim[0], prop.maxThreadsDim[1], prop.maxThreadsDim[2]);
        printf("\nDevice max grid size: %d %d %d", prop.maxGridSize[0], prop.maxGridSize[1], prop.maxGridSize[2]);
        printf("\nDevice total global mem: %zd", prop.totalGlobalMem);
        printf("\nDevice total constant mem: %zd", prop.totalConstMem);
        printf("\nDevice shared mem per block: %zd", prop.sharedMemPerBlock);
        printf("\nDevice regs per block: %d", prop.regsPerBlock);
        printf("\nDevice multiprocessor count: %d", prop.multiProcessorCount);
        printf("\nDevice L2 cache size: %d", prop.l2CacheSize);
        printf("\nDevice max threads per multiprocessor: %d", prop.maxThreadsPerMultiProcessor);
        printf("\nDevice compute mode: %d", prop.computeMode);
        printf("\nDevice concurrent kernels: %d", prop.concurrentKernels);
        printf("\nDevice async engine count: %d", prop.asyncEngineCount);
        printf("\nDevice unified addressing: %d", prop.unifiedAddressing);
        printf("\nDevice memory pitch: %zd", prop.memPitch);
        printf("\nDevice texture alignment: %zd", prop.textureAlignment);
        printf("\nDevice device overlap: %d", prop.deviceOverlap);
        printf("\nDevice kernel exec timeout enabled: %d", prop.kernelExecTimeoutEnabled);
        printf("\nDevice can map host memory: %d", prop.canMapHostMemory);
        printf("\nDevice compute capability major: %d", prop.major);
        printf("\nDevice single to double precision perf ratio: %d", prop.singleToDoublePrecisionPerfRatio);
        
    }

    int dev;
    cudaGetDevice( &dev ); 
    printf( "\nID of current CUDA device: %d\n", dev ); 
    
    return 0;
}
