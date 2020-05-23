module audio.jack;

import nogc.exception : enforce;

import jack.c.types : jack_nframes_t, JackTransportState, _jack_position, JackOptions, 
                      JackStatus, JackPortFlags, JACK_DEFAULT_AUDIO_TYPE;
import jack.client : JackClient;
import mixer;
version (Posix) import core.sys.posix.pthread : pthread_self;
import core.thread : Thread, ThreadID;
import core.time : msecs;
import std.conv : emplace;
import dsp;

@safe @nogc:

/// create and setup jack client and ports
/// currently trusted because we need to access the __gshared mixer stuff.
/// hopefully I will come up with a better design
void open() @trusted @nogc 
{
    emplace(&client, "subterrianian", JackOptions.NullOption, status);
    enforce( client.empty == false, "failed to create jack client" );

    foreach (ref input; mixer.inputs)
    {
        foreach (ref channel; input.channels)
        {
            channel.port = client.registerPort (channel.name, JACK_DEFAULT_AUDIO_TYPE, JackPortFlags.IsInput);
        }
    }

    foreach (ref output; mixer.outputs)
    {
        foreach (ref channel; output.channels)
        {
            channel.port = client.registerPort (channel.name, JACK_DEFAULT_AUDIO_TYPE, JackPortFlags.IsOutput);
        }
    }

    client.processCallback = &process;
    client.sampleRateCallback = &adjust_samplerate;
    client.conditionalTimebaseCallback = &adjust_timebase;
    client.onShutdownCallback = &on_shutdown;
}

/// we are done with our jack client 
void close() @trusted
{
    client.destroy() ;
}

/// tell jack that we are ready to start receiving data 
/// currently @trusted because of Thread.sleep
void start() @trusted
{
    client.activate();

    auto ports = client.getPorts(null,null,JackPortFlags.IsInput|JackPortFlags.IsPhysical);
    enforce( ports.length != 0, "no input ports found" );
    ports.destroy();
    
    ports = client.getPorts(null,null,JackPortFlags.IsOutput|JackPortFlags.IsPhysical);
    enforce ( ports.length != 0, "no output ports found" );
    ports.destroy();

    version (Posix) { while (thread_id == 0) Thread.sleep(msecs(10)); }
    else assert (0, "Posix only supported currently");

}

/// stop receiving data from jack server
void stop() @safe
{
    client.deactivate();
}

/// c callbacks 
extern (C) @nogc nothrow
{
    /// main function that allows us to take recieve and send data to the jack server.
    int process (jack_nframes_t nframes, void *_) @trusted
    {
        version (Posix) { if (thread_id == 0) thread_id = pthread_self(); }

        // since the buffers in a jack port are volitile and may not line up
        // between different invocations of the process function
        // some setup is needed to make sure we have the correct buffers
        foreach (ref stream; mixer.streams)
        {
            foreach (ref channel; stream.channels)
            {
                channel.buffer = channel.port.buffer!(float)[0..nframes];
            }
        }

        dsp.process();
        return 0;
    }

    /// callback to deal with sample rate changing on the jack server
    int adjust_samplerate (jack_nframes_t nframes, void *_) @trusted
    {
        return 0;
    }

    /// callback to deal with timebase changing on the jack server
    void adjust_timebase(JackTransportState state, jack_nframes_t nframes, _jack_position * pos, int new_pos, void *_ )
    {

    }
    /// what to do if the jack server shuts down
    void on_shutdown (void *_)
    {
        
    }
}

private JackClient client;
private JackStatus status;
private ThreadID thread_id;