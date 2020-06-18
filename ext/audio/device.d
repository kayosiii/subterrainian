// module ext.audio.device;
// import std.typecons : Nullable;
// Nullable!AudioDevice getDefaultAudioInputDevice()
// {
//     return null;
// }

// Nullable!AudioDevice getDefaultAudioOutputDevice()
// {
//     return null;
// }

// Nullable!AudioDevice[] getAudioInputDeviceList()
// {
//     return null;
// }

// Nullable!AudioDevice[] getAudioOputDeviceList()
// {
//     return null;
// }

// enum AudioDeviceListEvent
// {
//     DeviceListChanged,
//     DefaultInputDeviceChanged,
//     DefaultOutputDeviceChanged
// }

// struct AudioDevice
// {
//     immutable string name;
//     // device_id_t deviceID;
//     bool isInput;
//     bool isOutput;
    
//     @property int numInputChannels()
//     {
//         return 0;
//     }
//     @property int numOutputChannels()
//     {
//         return 0;
//     }
//     // @property sample_rate_t sampleRate()
//     // {
//     //     return 0;
//     // } 
//     // @property void sampleRate(sample_rate_t rate)
//     // {

//     // }
//     @property buffer_size_t bufferSize()
//     {
//         return 0;
//     }
//     @property void bufferSize(bufferSize size)
//     {

//     }
//     bool supportsSampleType(T)()
//     {
//         return false;
//     }
//     /*enum*/ bool canConnect();
//     /*enum*/ bool canProcess();

//     void connect(AudioIOCallback ioCallback);
//     bool start(AudioDeviceCallback startCallback, AudioDeviceCallback stopCallback)
//     {
//         return false;
//     } 
//     bool stop ()
//     {
//         return false;
//     }
//     @property bool isRunning()
//     {
//         return false;
//     }
//     void wait() const
//     {

//     }
//     void process(AudioIOCallback iocallback)
//     {

//     }
//     @property bool hasUnprocessedIO()
//     {
//         return false;
//     }
// }

// struct AudioDeviceIO
// {
//     Nullable!(AudioBuffer!SampleType) inputBuffer;
//     Nullable!(timePoint!audio_clock_t) inputTime;
//     Nullable!(AudioBuffer!SampleType) outputBuffer;
//     Nullable!(timePoint!audio_clock_t) outputTime;
// }