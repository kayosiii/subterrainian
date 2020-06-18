module loops;
import std.math : sin,PI,ceil,abs;
alias π = PI;
import std.algorithm.searching : maxElement;

import core.atomic : atomicOp, atomicLoad, atomicStore;
import std.algorithm.iteration : sum;
import std.algorithm.comparison : min;

import memory;

import jack.c.types : jack_default_audio_sample_t, jack_nframes_t;
alias audio_sample_t = jack_default_audio_sample_t;
alias nframes_t = jack_nframes_t;
import filesystem : loopAuxDataChunkSize;
import memory;

struct FastArray(T)
{
    T[] items;
    size_t firstEmpty;

}

struct LoopPlayerSimple
{
    audio_sample_t[] samples;
    nframes_t nframes;
    audio_sample_t[2][] buf;
    size_t pos;

    void opAssign(LoopRecorder src)
    {
        // start with the last partially full chunk
        size_t sz = src.finalSample;
        AudioChunk* chunk = src.head;
        // add all the completed chunks
        while( chunk != src.tail )
        {
            sz += chunk.length;
            chunk = chunk.next;
        }
        memory.allocator.makeArray!audio_sample_t (sz);
        size_t offset = 0;
        chunk = src.head;
        while(chunk != src.tail)
        {
            samples[offset..offset+chunk.length] = chunk.samples[0..$];
            offset += chunk.length;
            chunk = chunk.next;
        }
        chunk.samples[offset..$] = chunk.samples[0..src.finalSample];
    }

    @property bool empty () { return cast(bool) samples.length; }
    @property audio_sample_t[2][] front() { return buf;}

    void popFront()
    {
        if (pos+nframes <= samples.length)
        {
            buf[0] = samples [pos..pos+nframes];
            pos += nframes;
            buf[1] = null;
        }
        else
        {
            auto overflow = (pos+nframes) - samples.length;
            buf[0] = samples [pos..$];
            buf[1] = samples [0..overflow];
            pos = overflow;
        }
    }

    audio_sample_t[2][] take (nframes_t n)
    {
        if (pos+n <= samples.length)
        {
            buf[0] = samples [pos..pos+n];
            buf[1] = null;
            pos += n;
        }
        else
        {
            buf[0] = samples[pos..$];
            auto overflow = (pos+n) - samples.length;
            buf[1] = samples [0..overflow];
            pos = overflow;
        }
        return buf;
    }
    //overdub
    void put(audio_sample_t[] src)
    {
        if(src.length <= samples.length - pos)
        {
            samples [pos..pos+src.length] = samples[pos..pos+src.length] * 0.5 + src[] * 0.5;
            pos += src.length; 
        }
        else 
        {
            auto overflow = src.length - (samples.length - pos);
            samples [pos..$] = samples[pos..$] * 0.5 + src[0..overflow] * 0.5;
            samples [0..overflow] = samples[0..overflow] * 0.5 + src[0..overflow] * 0.5;
            pos = overflow;
        }
    }

    import tmp : lerp;
}


struct LoopRecorder
{
    AudioChunk *head;
    AudioChunk *tail;
    AudioChunk *readChunk;
    AudioChunk *writeChunk;
    size_t finalSample;
    audio_sample_t[] read;
    audio_sample_t[] write; 
    audio_sample_t[2][] buf;
    nframes_t nframes;

    @property bool empty () { return cast(bool) head.length; }
    @property audio_sample_t[2][] front ()
    {
        return buf;
    }
    audio_sample_t[2][] take (nframes_t n)
    {
        if(n <= read.length)
        {
            buf[0] = read[0..n];
            buf[1] = null;
            read = read[n..$];   
        }
        else 
        {
            buf[0] = read[0..$];
            readChunk = (readChunk.next == null) ? head : readChunk.next;
            read = (readChunk.next == null) ? readChunk.samples[0..finalSample] : readChunk.samples[];
            auto spillover = n - read.length;
            buf[1] = read[0..spillover];
            read = read[spillover..$];
        }
        return buf;
    }
    void popFront()
    {
        if (nframes <= read.length)
        {
            buf[0] = read[0..nframes];
            buf[1] = null;
            read = read[nframes..$]; 
        }
        else 
        {
            auto spillover = nframes - read.length;
            buf[0] = read[0..$];
            readChunk = (readChunk.next == null) ? head : readChunk.next;
            read = (readChunk.next == null) ? readChunk.samples[0..finalSample] : readChunk.samples[];
            buf[1] = read[0..spillover];
            read = read[spillover..$];
        }

    }
    void put(audio_sample_t[] src)
    {
        if (write.length < src.length)
        {
            write[] = src[];
            write = write[src.length..$];
        }
        else
        {
            auto spillover = src.length - write.length;
            write[] = src[0..spillover];
            tail.next = memory.recorderChunks.read();
            tail = tail.next;
            writeChunk = writeChunk.next;
            write = writeChunk.samples[0..$];
            write[] = src[spillover..$];
            write = write[spillover..$];
        }
    }
    void addChunk (AudioChunk* chunk)
    {
        tail.next = chunk;
        chunk = tail;
    }
}

void process()
{
    foreach (ref recorder; recorders.recording)
    {
        foreach (i, ref channel; mixer.summedInput)
        {
            recorder.channels[i].put(channel);
        }
    }
    foreach (ref loop; loopSet.overdubs)
    {
        foreach (i, ref channel; mixer.summedInput)
        {
            loop.channels[i].put(channel);
        }
    }
    foreach (ref recorder; recorders.playing)
    {
        
    }
    foreach (ref loop; loopSet.active)
    {
        foreach()
    }
}

void recordPressed (uint loopid)
{
    recorders.firstEmpty++;
}

void lock() @safe @nogc nothrow
{

}
void unlock() @safe @nogc nothrow
{

}

struct LoopData
{
    float pos = 256.0;
    audio_sample_t[] peaks;
    audio_sample_t[] averages;
    float triggerVolume;
}

shared LoopData _data;
immutable(audio_sample_t[]) testData;
ref shared(LoopData) getLoopAuxData(int id) @safe @nogc nothrow
{   
    float p = _data.pos.atomicLoad();
    p += 125;
    if (p >= testData.length) 
    {
        p -= testData.length;
    }
    
    _data.pos.atomicStore(p);

    return _data;
}

shared static this()
{
    testData = cast(immutable(float[])) memory.allocator.makeArray!audio_sample_t(48_000);
    float pos = 0;
    foreach(ref sample; testData) 
    { 
        sample = sin(2.0*π*60.0*pos/48_000.0);
        pos += 1.0;
    }
    int auxSize = cast(int)ceil(48_000.0/cast(double)loopAuxDataChunkSize);
    _data.peaks = memory.allocator.makeArray!(shared audio_sample_t)(auxSize);
    _data.averages = memory.allocator.makeArray!(shared audio_sample_t)(auxSize);
    audio_sample_t[] tmp;
    foreach(i; 0..auxSize)
    {
        tmp = cast(float[]) testData[i*auxSize..min((i+1)*auxSize,$)];
        _data.peaks[i] = tmp.maxElement!"abs(a)";
        _data.averages[i] = abs(tmp.sum / tmp.length);
    }
}

shared static ~this()
{
     memory.allocator.dispose(cast(audio_sample_t[])testData);
     memory.allocator.dispose(cast(audio_sample_t[])_data.peaks);
     memory.allocator.dispose(cast(audio_sample_t[])_data.averages);
}