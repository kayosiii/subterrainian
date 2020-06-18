module sdl2.surface;
import vectortype;
import sdl2.c.types: SDL_Surface, SDL_bool, SDL_SurfaceFlags;
public import sdl2.c.types : SDL_Palette, SDL_RWops, SDL_Color, SDL_BlendMode, SDL_Rect, SDL_PixelFormat,
                             SDL_PixelFormatEnum, SDL_TextureAccess;
                              

struct SDLSurface
{

    this(uint flags, int width, int height, int depth, vec4!uint mask) @trusted @nogc nothrow
    {
        ptr = SDL_CreateRGBSurface(flags, width, height, depth, mask.r,mask.g,mask.b,mask.a);
    }
    this(uint flags, int width, int height, int depth, uint format) @trusted @nogc nothrow
    {
        ptr = SDL_CreateRGBSurfaceWithFormat(flags,width,height,depth,format);
    }
    this(void[] pixels, int width, int height, int depth, int pitch, vec4!uint mask) @trusted @nogc nothrow
    {
        ptr = SDL_CreateRGBSurfaceFrom(pixels.ptr, width, height, depth, pitch, mask.r, mask.g, mask.b, mask.a);
    }
    this(void[] pixels, int width, int height, int depth, int pitch, uint format) @trusted @nogc nothrow
    {
        ptr = SDL_CreateRGBSurfaceWithFormatFrom(pixels.ptr,width,height,depth,pitch,format);
    }
    this(SDL_Surface * sf) @trusted @nogc nothrow
    {
        ptr = sf;
    }
    this(ref SDL_RWops ops, int i) @trusted @nogc nothrow
    {
        ptr = SDL_LoadBMP_RW(&ops,i);
    }
    ~this() @trusted @nogc nothrow
    {
        SDL_FreeSurface(ptr);
    }
    @property bool isNull() @trusted @nogc nothrow
    {
        return (ptr == null);
    }
    @property T[] pixels(T) () @trusted @nogc nothrow
    in { assert(ptr.format.BytesPerPixel == T.sizeof,"surface is not in the right bitdeth");}
    body
    {

        return cast(T[]) ptr.pixels[0..ptr.w*ptr.h*ptr.format.BytesPerPixel];
    }
    @property void[] pixels () @trusted @nogc nothrow
    {
        return cast(void[]) ptr.pixels[0..ptr.w*ptr.h*ptr.format.BytesPerPixel];
    }
    @property void palette (ref SDL_Palette pal) @trusted @nogc nothrow
    {
        SDL_SetSurfacePalette(ptr,&pal);
    }

    @property bool mustLock()
    {
        return (ptr.flags & SDL_SurfaceFlags.RLEACCEL) != 0;
    }
    int lock () @trusted @nogc nothrow
    {
        return SDL_LockSurface(ptr);
    }
    void unlock () @trusted @nogc nothrow
    {
        SDL_UnlockSurface(ptr);
    }
    void saveBMP (ref SDL_RWops ops, int i) @trusted @nogc nothrow
    {
        SDL_SaveBMP_RW(ptr,&ops, i);
    }
    @property void RLE(int i) @trusted @nogc nothrow
    {
        SDL_SetSurfaceRLE(ptr,i);
    }
    @property colorKey(bool enable, uint key) @trusted @nogc nothrow
    {
        SDL_SetColorKey(ptr,cast(SDL_bool)enable, key);
    }
    @property bool hasColorKey() @trusted @nogc nothrow
    {
        return cast(bool) SDL_HasColorKey(ptr);
    }
    @property uint colorKey() @trusted @nogc nothrow
    {
        uint key;
        SDL_GetColorKey(ptr,&key);
        return key;
    }
    @property void rgbaMod (SDL_Color c) @trusted @nogc nothrow
    {
        SDL_SetSurfaceColorMod(ptr,c.r, c.g, c.b);
        SDL_SetSurfaceAlphaMod(ptr,c.a);
    }
    @property SDL_Color rgbaMod () @trusted @nogc nothrow
    {
        SDL_Color c;
        SDL_GetSurfaceColorMod(ptr, &c.r, &c.g, &c.b);
        SDL_GetSurfaceAlphaMod(ptr,&c.a);
        return c;
    }
    @property void colorMod (SDL_Color c) @trusted @nogc nothrow
    {
        SDL_SetSurfaceColorMod(ptr,c.r, c.g, c.b);
    }
    @property SDL_Color colorMod () @trusted @nogc nothrow
    {
        SDL_Color c;
        SDL_GetSurfaceColorMod(ptr, &c.r, &c.g, &c.b);
        return c;
    }
    @property void alphaMod (ubyte alpha) @trusted @nogc nothrow
    {
        SDL_SetSurfaceAlphaMod(ptr,alpha);
    }
    @property uint alphaMod() @trusted @nogc nothrow
    {
        ubyte r;
        SDL_GetSurfaceAlphaMod(ptr,&r);
        return r;
    }
    @property void blendMode (SDL_BlendMode mode) @trusted @nogc nothrow
    {
        SDL_SetSurfaceBlendMode(ptr,mode);
    }
    @property SDL_BlendMode blendMode () @trusted @nogc nothrow
    {
        SDL_BlendMode r;
        SDL_GetSurfaceBlendMode (ptr,&r);
        return r;
    }
    @property void clipRect (ref const(SDL_Rect) r) @trusted @nogc nothrow
    {
        SDL_SetClipRect(ptr,&r);
    }
    @property SDL_Rect clipRect () @trusted @nogc nothrow
    {
        SDL_Rect r;
        SDL_GetClipRect(ptr,&r);
        return r;
    }
    SDLSurface duplicate() @trusted @nogc nothrow
    {
        return SDLSurface(SDL_DuplicateSurface(ptr));
    }
    SDLSurface convert(ref const(SDL_PixelFormat) fmt, uint i) @trusted @nogc nothrow
    {
        return SDLSurface(SDL_ConvertSurface(ptr,&fmt,i));
    }
    SDLSurface convertFormat(uint fmt) @trusted @nogc nothrow
    {
        return SDLSurface(SDL_ConvertSurfaceFormat(ptr, fmt, 0));
    }

    // int convertPixels()
    void fill(SDL_Color c) @trusted @nogc nothrow
    {
        SDL_FillRect(ptr,null,SDL_MapRGBA(ptr.format,c.r,c.g,c.b,c.a));
    }
    void fillRect(ref const(SDL_Rect) r, SDL_Color c) @trusted @nogc nothrow
    {
        SDL_FillRect(ptr,&r,SDL_MapRGBA(ptr.format,c.r,c.g,c.b,c.a));
    }
    void fillRects(ref const(SDL_Rect)[] rects, SDL_Color c) @trusted @nogc nothrow
    {
        SDL_FillRects(ptr,rects.ptr,cast(int)rects.length,SDL_MapRGBA(ptr.format,c.r,c.g,c.b,c.a));
    }
    void upperBlit( ref const(SDL_Rect) r, ref SDLSurface dest, ref SDL_Rect dest_r) @trusted @nogc nothrow
    {
        SDL_UpperBlit(ptr,&r,dest.ptr,&dest_r);
    }
    void lowerBlit( ref SDL_Rect r, ref SDLSurface dest, ref SDL_Rect dest_r) @trusted @nogc nothrow
    {
        SDL_LowerBlit(ptr,&r,dest.ptr,&dest_r);
    }
    void upperBlitScaled( ref const(SDL_Rect) r, ref SDLSurface dest, ref SDL_Rect dest_r) @trusted @nogc nothrow
    {
        SDL_UpperBlitScaled(ptr,&r,dest.ptr,&dest_r);
    }
    void lowerBlitScaled( ref SDL_Rect r, ref SDLSurface dest, ref SDL_Rect dest_r) @trusted @nogc nothrow
    {
        SDL_LowerBlitScaled(ptr,&r,dest.ptr,&dest_r);
    }
    void softStretch (ref const(SDL_Rect) r,ref SDLSurface dest, ref SDL_Rect dest_r) @trusted @nogc nothrow
    {
        SDL_SoftStretch(ptr,&r,dest.ptr,&dest_r);
    }
    SDL_Surface * ptr;
    alias ptr this;

    import sdl2.c.sdl : SDL_CreateRGBSurface, SDL_CreateRGBSurfaceWithFormat, SDL_CreateRGBSurfaceFrom,
                    SDL_CreateRGBSurfaceWithFormatFrom, SDL_FreeSurface, SDL_SetSurfacePalette,
                    SDL_LockSurface, SDL_UnlockSurface, SDL_LoadBMP_RW, SDL_SaveBMP_RW, 
                    SDL_SetSurfaceRLE, SDL_SetColorKey, SDL_HasColorKey, SDL_GetColorKey,
                    SDL_SetSurfaceColorMod, SDL_GetSurfaceColorMod, SDL_SetSurfaceAlphaMod,
                    SDL_GetSurfaceAlphaMod, SDL_SetSurfaceBlendMode, SDL_GetSurfaceBlendMode,
                    SDL_SetClipRect, SDL_GetClipRect, SDL_DuplicateSurface, SDL_ConvertSurface,
                    SDL_ConvertSurfaceFormat, SDL_ConvertPixels, SDL_FillRect, SDL_FillRects,
                    SDL_UpperBlit, SDL_LowerBlit, SDL_SoftStretch, SDL_UpperBlitScaled,
                    SDL_LowerBlitScaled, SDL_MapRGBA; 
}