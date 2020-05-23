module sdl2.renderer;

import vector;
public import sdl2.c.types : SDL_Rect, SDLRect, SDL_Renderer, SDL_BlendMode,
                             SDL_RendererInfo, SDL_Window, SDL_Surface, SDL_bool,
                             SDL_RendererFlags, SDL_Color;
@property int numDrivers() @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_GetNumRenderDrivers;
    return SDL_GetNumRenderDrivers();
}

int getDriverInfo(int n, ref SDL_RendererInfo info) @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_GetRenderDriverInfo;
    return SDL_GetRenderDriverInfo(n,&info);
} 

struct SDLRenderer
{
    import sdl2.c.sdl : SDL_CreateRenderer, SDL_CreateSoftwareRenderer, SDL_GetRenderer,
                        SDL_GetRendererInfo, SDL_GetRendererOutputSize, SDL_CreateTexture,
                        SDL_CreateTextureFromSurface, SDL_RenderTargetSupported, SDL_SetRenderTarget,
                        SDL_GetRenderTarget, SDL_RenderSetLogicalSize, SDL_RenderGetLogicalSize,
                        SDL_RenderSetIntegerScale, SDL_RenderGetIntegerScale, SDL_RenderSetViewport,
                        SDL_RenderGetViewport, SDL_RenderSetClipRect, SDL_RenderGetClipRect,
                        SDL_RenderIsClipEnabled, SDL_RenderSetScale, SDL_RenderGetScale,
                        SDL_SetRenderDrawColor, SDL_GetRenderDrawColor, SDL_SetRenderDrawBlendMode,
                        SDL_GetRenderDrawBlendMode, SDL_RenderClear, SDL_RenderDrawPoint,
                        SDL_RenderDrawPoints, SDL_RenderDrawLine, SDL_RenderDrawLines,
                        SDL_RenderDrawRect, SDL_RenderDrawRects, SDL_RenderFillRect, SDL_RenderFillRects,
                        SDL_RenderCopy, SDL_RenderCopyEx, SDL_RenderDrawPointF, SDL_RenderDrawPointsF,
                        SDL_RenderDrawLineF, SDL_RenderDrawLinesF, SDL_RenderDrawRectF,
                        SDL_RenderDrawRectsF, SDL_RenderFillRectF, SDL_RenderFillRectsF,
                        SDL_RenderCopyF, SDL_RenderCopyExF, SDL_RenderReadPixels, SDL_RenderPresent,
                        SDL_DestroyRenderer, SDL_RenderFlush, SDL_RenderGetMetalLayer;
    
    this (SDL_Window * window, int index, uint flags) nothrow @nogc @trusted
    {
        ptr = SDL_CreateRenderer(window,index,flags);
    }
    this (SDL_Surface *surface) nothrow @nogc @trusted
    {
        ptr = SDL_CreateSoftwareRenderer(surface);
    }
    this (SDL_Window *window) nothrow @nogc @trusted
    {
        ptr = SDL_GetRenderer(window);
    }
    ~this() nothrow @nogc @trusted
    {
        SDL_DestroyRenderer(ptr);
    }

    int info(ref SDL_RendererInfo info) nothrow @nogc @trusted
    {
        return SDL_GetRendererInfo(ptr,&info);
    }

    @property bool targetSupported() nothrow @nogc @trusted
    {
        return cast(bool) SDL_RenderTargetSupported(ptr);
    }
    // @property void target( SDLTexture tex) nothrow @nogc @trusted
    // {
    //     SDL_SetRenderTarget(ptr,tex.ptr);
    // }
    // @property SDLTexture target() nothrow @nogc @trusted
    // {
    //     return SDLTexture(SDL_GetRenderTarget(ptr));
    // }
    @property void logicalSize(vec2!int sz) nothrow @nogc @trusted
    {
        SDL_RenderSetLogicalSize(ptr,sz.x,sz.y);
    }
    @property vec2!int logicalSize() nothrow @nogc @trusted
    {
        vec2!int r;
        SDL_RenderGetLogicalSize(ptr,&r.x,&r.y);
        return r;
    }
    @property void integerScaling (bool b) nothrow @nogc @trusted
    {
        SDL_RenderSetIntegerScale(ptr,cast(SDL_bool)b);
    }
    @property bool integerScaling () nothrow @nogc @trusted
    {
        return cast(bool) SDL_RenderGetIntegerScale(ptr);
    }
    @property void viewport (ref const(SDL_Rect) v) nothrow @nogc @trusted
    {
        SDL_RenderSetViewport(ptr,&v);
    }
    @property SDL_Rect viewport () nothrow @nogc @trusted
    {
        SDL_Rect r;
        SDL_RenderGetViewport(ptr,&r);
        return r;
    }
    @property void clipRect(ref const(SDL_Rect) c) nothrow @nogc @trusted
    {
        SDL_RenderSetClipRect(ptr,&c);
    }
    @property SDL_Rect clipRect () nothrow @nogc @trusted
    {
        SDL_Rect r;
        SDL_RenderGetClipRect(ptr,&r);
        return r;
    }
    @property bool isClipEnabled() nothrow @nogc @trusted
    {
        return cast(bool) SDL_RenderIsClipEnabled(ptr);
    }
    @property void scale(vec2!float scale) nothrow @nogc @trusted
    {
        SDL_RenderSetScale(ptr,scale.x,scale.y);
    }
    @property vec2!float scale() nothrow @nogc @trusted
    {
        vec2!float r;
        SDL_RenderGetScale(ptr,&r.x,&r.y);
        return r;
    }
    @property void color(SDL_Color c) nothrow @nogc @trusted
    {
        SDL_SetRenderDrawColor(ptr,c.r,c.g,c.b,c.a);
    }
    @property SDL_Color color () nothrow @nogc @trusted
    {
        SDL_Color r;
        SDL_GetRenderDrawColor(ptr,&r.r,&r.g,&r.b,&r.a);
        return r;
    }
    @property void blendMode (SDL_BlendMode m) nothrow @nogc @trusted
    {
        SDL_SetRenderDrawBlendMode(ptr,m);
    } 
    @property SDL_BlendMode blendMode () nothrow @nogc @trusted
    {
        SDL_BlendMode r;
        SDL_GetRenderDrawBlendMode(ptr,&r);
        return r;
    }
    @property vec2!int outputSize() nothrow @nogc @trusted
    {
        vec2!int r;
        SDL_GetRendererOutputSize(ptr,&r.x,&r.y);
        return r;
    }

    void clear () nothrow @nogc @trusted
    {
       SDL_RenderClear(ptr); 
    }
    void drawPoint(T) (const(vec2!T) pt) nothrow @nogc @trusted
        if (is(T == float) || is(T == int))
    {
        static if (is(T == int))
            SDL_RenderDrawPoint(ptr,pt.x,pt.y);
        else 
            SDL_RenderDrawPointF(ptr,pt.x,pt.y);
    }
    void drawPoints(T)(const(SDL_Point!T)[] pts) nothrow @nogc @trusted
        if (is(T == float) || is(T == int))
    {
        static if (is(T == int))
            SDL_RenderDrawPoints(ptr,pts.ptr,pts.length);
        else 
            SDL_RenderDrawPointsF(ptr,pts.ptr,pts.length);
    }
    void drawLine(T) (const(vec4!T) pts) nothrow @nogc @trusted
        if (is(T == float) || is(T == int))
    {
        static if (is(T == int))
            SDL_RenderDrawLine(ptr,pts[0],pts[1],pts[2],pts[3]);
        else 
            SDL_RenderDrawLineF(ptr,pts[0],pts[1],pts[2],pts[3]);
    }

    void drawLines(T) (const(SDL_Point!T) pts) nothrow @nogc @trusted
        if (is(T == float) || is(T == int))
    {
        static if (is(T == int))
            SDL_RenderDrawLines(ptr,pts.ptr,pts.length);
        else
            SDL_RenderDrawLinesF(ptr,pts.ptr,pts.length);
    }

    void drawRect(T) (ref const(SDL_Rect!T) r) nothrow @nogc @trusted
        if (is(T == float) || is(T == int))
    {
        static if (is(T == int))
            SDL_RenderDrawRect(ptr,&r);
        else
            SDL_RenderDrawRectF(ptr,&r);
    }
    void drawRects(T) (const(SDL_Rect!T)[] r) nothrow @nogc @trusted
        if (is(T == float) || is(T == int))
    {
        static if (is(T == int))
            SDL_RenderDrawRects(ptr,r.ptr,r.length);
        else 
            SDL_RenderDrawRectsF(ptr,r.ptr,r.length);
    }
    void fillRect(T) (ref const(SDL_Rect!T) r) nothrow @nogc @trusted
        if (is(T == float) || is(T == int))
    {
        static if (is(T == int))
            SDL_RenderFillRect(ptr,&r);
        else 
            SDL_RenderFillRectF(ptr,&r);
    }
    void fillRects(T) (const(SDL_Rect!T)[] r) nothrow @nogc @trusted
        if (is(T == float) || is(T == int))
    {
        static if (is(T == int))
            SDL_RenderFillRects(ptr,r.ptr,r.length);
        else
            SDL_RenderFillRectsF(ptr,r.ptr,r.length);
    }
    void copy(T) (ref SDLTexture tex, ref const(SDL_Rect) src, ref const(SDL_Rect!T) dst) nothrow @nogc @trusted
        if (is(T == float) || is(T == int))
    {
       static if (is(T == int)) 
            SDL_RenderCopy(ptr,&tex,&src,&dst);
        else 
            SDL_RenderCopyF(ptr,&tex,&src,&dst);
    }
    void copyEx(T) (ref SDLTexture tex, ref const(SDL_Rect) src, ref const(SDL_Rect!T) dst) nothrow @nogc @trusted
    {
        static if (is(T == int))
            SDL_RenderCopyEx(ptr,&tex,&src,&dst);
        else 
            SDL_RenderCopyExF(ptr,&tex,&src,&dst);
    }
    void readPixels(ref const(SDLRect!int) r, uint fmt, void[] pixels, int pitch) nothrow @nogc @trusted
    {
        SDL_RenderReadPixels(ptr,&r,fmt,pixels.ptr,pitch);
    }
    void present () nothrow @nogc @trusted
    {
        SDL_RenderPresent(ptr);
    }
    void flush () nothrow @nogc @trusted
    {
        SDL_RenderFlush(ptr);
    }

    SDL_Renderer * ptr;
}