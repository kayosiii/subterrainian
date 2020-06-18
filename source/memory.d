module memory;

import std.experimental.allocator : RCIAllocator, allocatorObject;
public import std.experimental.allocator : make, dispose, makeArray, makeMultidimensionalArray, disposeMultidimensionalArray;
import std.experimental.allocator.mallocator;

import core.thread : Thread;
import core.time : msecs, Duration;

import jack.c.types :jack_default_audio_sample_t, jack_nframes_t;

alias allocator = Mallocator.instance;
alias stringAllocator = Mallocator.instance;
alias sharedAllocator = Mallocator.instance;

alias audio_sample_t = jack_default_audio_sample_t;
alias nframes_t = jack_nframes_t;

struct AudioChunk
{
    audio_sample_t[] samples;
    audio_sample_t[] peaks;
    audio_sample_t[] averages;
    alias samples this;
    AudioChunk *next;
}

shared struct CircularBuffer(T)
{
    this (const(size_t) size)
    {
        import std.math : nextPow2;
        _buffer = allocator.makeArray!T(nextPow2(size));
    }
    ~this()
    {
        allocator.dispose(cast(T)_buffer);
    }
    T read ()
    {
 
        immutable pos = atomicLoad!(MemoryOrder.acq)(_readPos);
        shared(T) r = _buffer[pos];
        atomicStore!(MemoryOrder.rel) (_readPos, (pos+1)&(_buffer.length-1) );
        return cast(T) r;
    }
    void write (T t)
    {
        auto u = cast(shared T) t;
        immutable pos = atomicLoad!(MemoryOrder.acq) (_writePos);
        _buffer[pos] = u;
        atomicStore!(MemoryOrder.rel) (_writePos, (pos+1)&(_buffer.length-1) );
    }
    @property size_t space ()
    {
        if (_readPos > _writePos) return _readPos - _writePos;   
        else return (_buffer.length - 1) - _writePos + _readPos;
    }
    bool full ()
    {
        return (((_writePos + 1) & (_buffer.length - 1)) == _readPos);
    }

    private
    {
        size_t _writePos;
        size_t _readPos;
        T[] _buffer;  
    }

    import core.atomic : atomicLoad, atomicStore, MemoryOrder;
}
CircularBuffer!(AudioChunk *) recorderChunks;
shared static this ()
{
    recorderChunks = CircularBuffer!(AudioChunk *)(16);
}


void start() @trusted nothrow
{
    thread.start ();
}

void stop() @nogc @trusted nothrow
{
    _running = false;
    while(thread.isRunning) Thread.sleep(msecs(10));
}

shared int[8] allRecorderIds;
shared int[] recorderIds;
size_t minQueueSize = 8;
shared bool _running;
Thread thread;

void run()
{
    _running = true;
    while(_running)
    {
        while(!recorderChunks.full) 
        {
            AudioChunk* newItem = allocator.make!AudioChunk();
            recorderChunks.write(newItem); 
        }
        Thread.sleep(msecs(10));
    }
}