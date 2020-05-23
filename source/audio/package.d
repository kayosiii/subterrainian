module audio;
version (jack) public import audio.jack : open, close, start, stop;
else 
{
    void open() @nogc @safe nothrow {}
    void close() @nogc @safe nothrow {}
    void start() @nogc @safe nothrow {}
    void stop() @nogc @safe nothrow {}
}
