module xlib;

private extern (C) int XInitThreads() @nogc nothrow;
pragma(inline) bool initThreads() @trusted @nogc nothrow
{  
    return cast(bool) XInitThreads(); 
} 