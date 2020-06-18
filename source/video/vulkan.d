module video.vulkan;

import erupted;
import memory;

struct VkContext
{
    VkInstance instance;
    VkSurfaceKHR surface;
    VkPhysicalDevice physicalDevice;
    VkDevice logicalDevice;
    ulong presentQueueFamilyIndex = -1;
    VkQueue presentQueue;
    uint width;
    uint height;
    VkSwapchainKHR swapchain;
    VkCommandBuffer setupCmdBuffer;
    VkCommandBuffer drawCmdBuffer;
    VkImage[] presentImages;
    VkImage depthImage;
    VkPhysicalDeviceMemoryProperties memoryProperties;
    VkImageView depthImageView;
    VkRenderPass renderPass;
    VkFramebuffer[] frameBuffers;
    VkBuffer vertexInputBuffer;
    VkPipelineLayout pipelineLayout;
    VkPipeline pipeline;
    VkSemaphore presentCompleteSemaphore, renderingCompleteSemaphore;
    @property ExtensionPropertyArray extensionProperties() { return ExtensionPropertyArray(0);}
    @property LayerPropertyArray layerProperties() { return LayerPropertyArray(0);}
}

alias DummyArg = int;

struct LayerPropertyArray
{
    @disable this(this);
    this(DummyArg _)
    {
        uint count;
        vkEnumerateInstanceLayerProperties(&count, null);
        memory.allocator.makeArray!VkLayerProperties(count);
        vkEnumerateInstanceLayerProperties(&count, props.ptr);
    }
    ~this()
    {
        memory.allocator.dispose(props);
    }
    VkLayerProperties[] props;
    alias props this;
}
struct ExtensionPropertyArray 
{
    @disable this(this);
    this(DummyArg _) // oh so janky
    {
       uint extensionCount;
       vkEnumerateInstanceExtensionProperties(null, &extensionCount, null ); 
       props = memory.allocator.makeArray!VkExtensionProperties(extensionCount);
       vkEnumerateInstanceExtensionProperties(null, &extensionCount, props.ptr );
    }
    ~this()
    {
        memory.allocator.dispose(props);
    }
    VkExtensionProperties[] props;
    alias props this;
}

void test()
{
    VkContext context;
    context.width = 1280; context.height = 720;
    VkApplicationInfo appInfo;
    string[3] extensionNames = 
    [
        "VK_KHR_surface",
        "VK_KHR_xlib_surface",
        "VK_EXT_debug_report"
    ];
    auto properties = context.extensionProperties;

    auto layers = context.layerProperties;

    

}