module config;

/// string list of suffixes for stereo audio streams
enum string[2] stereoChannelNames = ["l","r"];
/// ... 5.1 surround audio streams
enum string[6] surround5_1ChannelNames = ["c","l","r","sw","fl","fr"];
/// ... 5.1 surround audio streams
enum string[8] surround7_1ChannelNames = ["c","l","r","sw","fl","fr","bl","br"];

/// currently mono and stereo are implemented
enum StreamConfigType  
{
    MONO,
    STEREO,
    SURROUND_5_1,
    SURROUND_7_1,
    AMBISONIC
}

/// tells us the configuration of input and output audio ports
struct StreamConfig
{
    /// this is a unique identifier for the ports that make up this stream
    string name;
    /// number of ports needed to represent this logical grouping 
    int numChannels;
    /// because streams with the same number of ports can be used 
    /// in different ways we need to know more than just the 
    /// number of channels
    StreamConfigType type;
}

/// eventually this will be loaded from a configuration file
/// currently this is just a test
StreamConfig[] inputs = [StreamConfig("1",1,StreamConfigType.MONO)];
/// in our test we are going out to stereo speakers / headphones
StreamConfig[] outputs = [{"",2,StreamConfigType.STEREO}];