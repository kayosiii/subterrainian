module ext.audio.backend.dummy;

struct AudioDevice
{
    @disable this();

    @property string name () nothrow @nogc pure @safe { return "dummy"; }
    alias device_id_t = uint;
    @property device_id_t deviceID () nothrow pure @nogc @safe {return 0;}
    @property bool isInput () nothrow pure @nogc @safe { return false; }
    @property bool isOutput () nothrow pure @nogc @safe { return false; }
    @property int numInputChannels () nothrow pure @nogc @safe { return 0; }
    @property int numOutputChannels () nothrow pure @nogc @safe { return 0; }
    alias sample_rate_t = uint;
    @property sample_rate_t sampleRate() nothrow pure @nogc @safe  { return 0;}
    @property void sampleRate(sample_rate_t sr) nothrow pure @nogc @safe {}
    alias buffer_size_t = uint;
    @property sample_rate_t bufferSize() nothrow pure @nogc @safe { return 0; }
    @property void bufferSize(buffer_size_t sz)   nothrow pure @nogc @safe { }
    enum supportsSampleType(T)() {return false; };
    enum canConnect() {return false; }
    enum canProcess() { return false; }
    bool start()  nothrow pure @nogc @safe { return false; }
    bool stop() nothrow pure @nogc @safe { return false; }
    bool isRunning () nothrow pure @nogc @safe { return false; }
    void wait() pure @nogc @safe  {assert(0);}
    bool hasUnprocessedIO () nothrow pure @nogc @safe {return false; }
}

