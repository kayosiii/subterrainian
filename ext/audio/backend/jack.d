module audio.backend.jack;

// struct AudioDevice
// {
//     @disable this();
//     ~this()
//     {

//     }
//     @property string name()
//     {

//     }

//     alias device_id_t = ;
//     @property device_id_t id ()
//     {

//     }
//     @property bool isInput() const nothrow
//     {

//     }
//     @property bool isOutput() const nothrow
//     {

//     }
//     @property int numInputChannels() const nothrow @safe @nogc
//     {

//     }
//     @property int numOutputChannels() const nothrow @safe @nogc
//     {

//     }
//     alias sample_rate_t = jack_sample_rate_t;
//     @property sample_rate_t sampleRate() const nothrow @safe @nogc
//     {

//     }
//     @property void sampleRate(sample_rate_t rate) const nothrow @safe @nogc
//     {

//     }
//     alias buffer_size_t = size_t;
//     @property buffer_size_t bufferSizeFrames() const nothrow @safe @nogc
//     {

//     }
//     @property void bufferSizeFrames(buffer_size_t frames) const nothrow @safe @nogc
//     {

//     }
//     @property bool supportsSampleType(T)() const nothrow @safe @nogc
//     {

//     }
//     @property bool canconnect() const nothrow @safe @nogc pure
//     {
//         return true;
//     }
//     @property bool canProcess() const nothrow @safe @nogc pure
//     {
//         return true;
//     }
//     void connect (ConnectCallbackFunction fn)
//     {

//     }
//     bool stop()
//     {

//     }
//     @property bool isRunning ()
//     {

//     }
//     void process(ProcessCallbackFunction fn)
//     {

//     }
//     @property bool hasUnprocessedIO ()
//     {

//     }
// }