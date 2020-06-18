module audio.buffer;

struct AudioBuffer(T)
{
     @property bool isContiguous() nothrow @nogc @safe
     {
        final switch (audio.currentAPI) with (AudioAPIType)
        {
            case JACK: return true;
        }
        return false;
     }

    @property bool channelsAreContiguous () nothrow @nogc @safe
    {
        final switch (audio.currentAPI) with (AudioAPIType)
        {
            case JACK: return true;
        }
        return false;
    }
    @property bool framesAreContiguous () nothrow @nogc @safe
    {
        final switch (audio.currentAPI) with (AudioAPIType)
        {
            case JACK: return true;
        }
        return false;
    }
    @property size_t sizeChannels () nothrow @nogc @safe
    {
        final switch (audio.currentAPI) with (AudioAPIType)
        {
            case JACK: return 1;
        }
        return 0;
    }
    @property size_t sizeFrames () nothrow @nogc @safe
    {
        final switch (audio.currentAPI) with (AudioAPIType)
        {
            case JACK: return 1;
        }
        return 0;
    }
    @property size_t sizeSamples() nothrow @nogc @safe
    {
        return sizeChannels*sizeFrames;
    }
    T[] buffer;
}