// module audio.backend.coreaudio;

// alias __coreaudio_native_sample_type = float;
// import audio.buffer;

// struct __coreaudio_stream_config 
// {
//     AudioBuffer[] inputs;
//     AudioBuffer[] outputs;
// }

// struct AudioDevice
// {
//     this() {}
//     ~this () @nogc nothrow @safe
//     {
//         stop();
//     }
//     @property string name()
//     {
//         return _name;
//     }
    
//     alias device_id_t = AudioObjectID;
//     device_id_t deviceID ()
//     {
//         return _device_id;
//     }
//     @property bool isInput ()
//     {
//         return _config.inputs.length == 1;
//     }
//     @property bool isOutput ()
//     {
//         return _config.outputs.length == 1;
//     }
//     @property int numInputChannels ()
//     {
//         return isInput ?  _config.inputs[0].numBuffers : 0;
//     }
//     @property int numOutputChannels ()
//     {
//         return isOutput ? _config.outputs[0].numBuffers : 0;
//     }

//     alias sample_rate_t = double;
//     @property sample_rate_t sampleRate()
//     {
//         AudioObjectPropertyAddress pa = ;
//     }
// }
