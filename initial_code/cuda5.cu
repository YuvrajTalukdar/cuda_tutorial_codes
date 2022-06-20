
#include <stdlib.h>
#include <assert.h>
#include "nvapi.h"

class NvVideoMemoryMonitor
{
public:
    struct MemInfo
    {
        unsigned int DedicatedVideoMemoryInMB;
        unsigned int AvailableDedicatedVideoMemoryInMB;
        unsigned int CurrentAvailableDedicatedVideoMemoryInMB;
    };

    NvVideoMemoryMonitor()
        : m_GpuHandle(0)
    {
    }

    void Init()
    {
        NvAPI_Status Status = NvAPI_Initialize();
        assert(Status == NVAPI_OK);

        NvPhysicalGpuHandle NvGpuHandles[NVAPI_MAX_PHYSICAL_GPUS] = { 0 };
        NvU32 NvGpuCount = 0;
        Status = NvAPI_EnumPhysicalGPUs(NvGpuHandles, &NvGpuCount);
        assert(Status == NVAPI_OK);
        assert(NvGpuCount != 0);
        m_GpuHandle = NvGpuHandles[0];
    }

    void GetVideoMemoryInfo(MemInfo* pInfo)
    {
        NV_DISPLAY_DRIVER_MEMORY_INFO_V2 MemInfo = { 0 };
        MemInfo.version = NV_DISPLAY_DRIVER_MEMORY_INFO_VER_2;
        NvAPI_Status Status = NvAPI_GPU_GetMemoryInfo(m_GpuHandle, &MemInfo);
        assert(Status == NVAPI_OK);

        pInfo->DedicatedVideoMemoryInMB = MemInfo.dedicatedVideoMemory / 1024;
        pInfo->AvailableDedicatedVideoMemoryInMB = MemInfo.availableDedicatedVideoMemory / 1024;
        pInfo->CurrentAvailableDedicatedVideoMemoryInMB = MemInfo.curAvailableDedicatedVideoMemory / 1024;
    }

private:
    NvPhysicalGpuHandle m_GpuHandle;
};
