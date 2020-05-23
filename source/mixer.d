module mixer;

import jack.c.types : jack_default_audio_sample_t;
import jack.port : JackPort;
import core.thread : Thread, ThreadID;
import core.time : msecs;
import config;
import memory;

/// stores a single continuous set of audio data 
/// analogous to a port in jack.
/// a stream contains one channel if it represents a mono 
/// sink/source, two channels if stereo etc.
struct AudioChannel(T)
{
    /// how the port will be indentified by software interacting with jack
    string name; 
    /// point of access to jack specific functionality
    /// TODO thinking of moving this out back to the audio implementation
    /// in order to make this file implementatation agnostic.
    JackPort port;
    /// flat array of the current audio data for this channel.
    T[] buffer;

    alias buffer this;
}

/// rather than representing each audio port in a flat list
/// group them into logical groups based on function -
/// a logical group is called a stream.
struct AudioStream(T)
{

    /// all the values in the buffer get multiplied by this
    /// attenuating the signal.
    float volume;
    /// used to place the sound in a stereo or surround feild 
    /// eventually
    float[3] pos;
    /// streams can be:
    /// Mono (1 channel),
    /// Stero (2 channels)
    /// in the future possibly 5_1 and 7_1 surround sound or ambisonics.
    AudioChannel!T[] channels;

    alias channels this;
}
/// a flat list of all ports being used.
__gshared AudioStream!jack_default_audio_sample_t [] streams;
/// a slice representing the ports used for input
__gshared AudioStream!jack_default_audio_sample_t [] inputs;
/// a slice representing all the ports used for output
__gshared AudioStream!jack_default_audio_sample_t [] outputs;
/// the port used to go to speakers/ headphones
__gshared AudioStream!jack_default_audio_sample_t mainOutput;
/// all other output ports 
__gshared AudioStream!jack_default_audio_sample_t [] auxOutputs;


shared static this ()
{
    streams = memory.allocator.makeArray!(AudioStream!jack_default_audio_sample_t)(config.inputs.length + config.outputs.length);
    inputs = streams[0..config.inputs.length];
    outputs = streams[config.inputs.length..$];
    mainOutput = outputs[0];
    auxOutputs = outputs[1..$];

    foreach (i,ref input; inputs)
    {
        input.channels = memory.allocator.makeArray!(AudioChannel!jack_default_audio_sample_t)(config.inputs[i].numChannels);
        foreach (j, ref channel; input.channels)
        {
            channel.name = makeChannelName("input", config.inputs[i], j);
        }
    }
    foreach (i, ref output; outputs)
    {
        output.channels = memory.allocator.makeArray!(AudioChannel!jack_default_audio_sample_t)(config.outputs[i].numChannels);
        foreach (j, ref channel; output.channels)
        {
            if (i == 0) channel.name = makeChannelName("main", config.outputs[0]);
            else channel.name = makeChannelName("aux", config.outputs[i], j);
        }
    }
}

shared static ~this()
{
    foreach (ref stream; streams) 
    {
        foreach (ref channel; stream.channels) 
        {
            memory.stringAllocator.dispose(cast(void[])channel.name);
            memory.allocator.dispose(channel);
        }
        memory.allocator.dispose(stream);
    }
}

/// utility function used to generate channel names 
/// based on the logical grouping of the ports
private string makeChannelName(string type, StreamConfig cfg, size_t channelNum = 0)
{
    import config : StreamConfigType;
    string channel;

    switch (cfg.type) with (StreamConfigType)
    {
        case STEREO: channel =  config.stereoChannelNames[channelNum]; break;
        case SURROUND_5_1: channel = config.surround5_1ChannelNames[channelNum]; break;
        case SURROUND_7_1: channel = config.surround7_1ChannelNames[channelNum]; break;
        default: channel = ""; break;
    } 
    auto name = memory.stringAllocator.makeArray!char(type.length+cfg.name.length+1+channel.length);
    name[0..type.length] = type[0..$];
    name[type.length..type.length+cfg.name.length] = cfg.name[0..$];
    name[type.length+cfg.name.length] = '_';
    name[type.length+cfg.name.length+1..$] = channel[0..$];
    return cast(string) name;
}