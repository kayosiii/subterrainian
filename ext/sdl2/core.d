module sdl2.core;
public import sdl2.c.types : SDLInit;
import sdl2.c.sdl : SDL_Init,SDL_InitSubSystem,SDL_QuitSubSystem, SDL_Quit;

alias init = SDL_Init;
alias initSubsystem = SDL_InitSubSystem;
alias quitSubsystem = SDL_QuitSubSystem;
alias quit = SDL_Quit;

@property int CPUCount() @nogc nothrow @trusted
{
   import sdl2.c.sdl : SDL_GetCPUCount;
   return SDL_GetCPUCount();
}

@property int CPUCacheLineSize() @nogc nothrow @trusted
{
   import sdl2.c.sdl : SDL_GetCPUCacheLineSize;
   return SDL_GetCPUCacheLineSize();
}

@property bool hasRDTSC() @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_HasRDTSC;
    return cast(bool) SDL_HasRDTSC();
}

@property bool hasAltiVec() @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_HasAltiVec;
    return cast(bool) SDL_HasAltiVec();
}

@property bool hasMMX() @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_HasMMX;
    return cast(bool) SDL_HasMMX();
}

@property bool has3DNow() @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_Has3DNow;
    return cast(bool) SDL_Has3DNow();
}

@property bool hasSSE() @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_HasSSE;
    return cast(bool) SDL_HasSSE();
}
@property bool hasSSE2() @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_HasSSE2;
    return cast(bool) SDL_HasSSE2();
}
@property bool hasSSE3() @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_HasSSE3;
    return cast(bool) SDL_HasSSE3();
}
@property bool hasSSE41() @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_HasSSE41;
    return cast(bool) SDL_HasSSE41();
}
@property bool hasSSE42() @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_HasSSE42;
    return cast(bool) SDL_HasSSE42();
}
@property bool hasAVX() @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_HasAVX;
    return cast(bool) SDL_HasAVX();
}
@property bool hasAVX2() @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_HasAVX2;
    return cast(bool) SDL_HasAVX2();
}
@property bool hasAVX512F() @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_HasAVX512F;
    return cast(bool) SDL_HasAVX512F();
}
@property bool hasNEON() @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_HasNEON;
    return cast(bool) SDL_HasNEON();
}

@property int systemRam() @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_GetSystemRAM;
    return SDL_GetSystemRAM();
}
