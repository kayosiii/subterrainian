module sdl2.simd;
import core.stdc.config;


@property c_ulong alignment() @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_SIMDGetAlignment;
    return SDL_SIMDGetAlignment();
}

void [] alloc (const(c_ulong) length) @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_SIMDAlloc;
    auto tmp = SDL_SIMDAlloc(length);
    return tmp[0..length];
}

void free(void[] mem) @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_SIMDFree;
    SDL_SIMDFree(mem.ptr);
}

// static ushort swap16(ushort i) @nogc nothrow @trusted
// {
//     import sdl2.c.sdl : SDL_Swap16;
//     return SDL_Swap16(i);
// }
// static uint swap32(uint i) @nogc nothrow @trusted
// {
//     import sdl2.c.sdl : SDL_Swap32;
//     return SDL_Swap32(i);
// }
// static c_ulong swap64(c_ulong i) @nogc nothrow @trusted
// {
//     import sdl2.c.sdl : SDL_Swap64;
//     return SDL_Swap64(i);
// }

// static ushort swapFloat(float f) @nogc nothrow @trusted
// {
//     import sdl2.c.sdl : SDL_SwapFloat;
//     return SDL_SwapFloat(f);
// }