module sdl2.renderer;

import vectortype;
public import sdl2.c.types : SDL_Rect, SDLRect, SDL_Renderer, SDL_BlendMode,
                             SDL_RendererInfo, SDL_Window, SDL_Surface, SDL_bool,
                             SDL_RendererFlags, SDL_Color, SDL_Texture;
import sdl2.surface;

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
struct SDLTexture
{
    import sdl2.c.sdl : SDL_CreateTexture, SDL_CreateTextureFromSurface, 
                        SDL_QueryTexture, SDL_SetTextureColorMod, SDL_GetTextureColorMod,
                        SDL_SetTextureAlphaMod, SDL_GetTextureAlphaMod, SDL_SetTextureBlendMode,
                        SDL_GetTextureBlendMode, SDL_UpdateTexture, SDL_UpdateYUVTexture,
                        SDL_LockTexture, SDL_UnlockTexture, SDL_DestroyTexture,
                        SDL_GL_BindTexture, SDL_GL_UnbindTexture;

    this(ref SDLRenderer r, uint format, SDL_TextureAccess access, int w, int h) nothrow @nogc @trusted
    {
        ptr = SDL_CreateTexture(r.ptr,format,access,w,h);
    }
    this(ref SDLRenderer r, ref SDLSurface s) nothrow @nogc @trusted
    {
        ptr = SDL_CreateTextureFromSurface(r.ptr,s.ptr);
    }
    ~this() nothrow @nogc @trusted
    {
        SDL_DestroyTexture(ptr);
    }

    int query (ref uint format, ref int access, ref int w, ref int h) nothrow @nogc @trusted
    {
        return SDL_QueryTexture(ptr, &format, &access, &w, &h);
    }
    @property void rgbaMod(SDL_Color mod) nothrow @nogc @trusted
    {
        SDL_SetTextureColorMod(ptr,mod.r,mod.g,mod.b);
        SDL_SetTextureAlphaMod(ptr,mod.a);
    }
    @property SDL_Color rgbaMod() nothrow @nogc @trusted
    {
        SDL_Color r;
        SDL_GetTextureColorMod(ptr,&r.r,&r.g,&r.b);
        SDL_GetTextureAlphaMod(ptr,&r.a);
        return r;
    }
    @property void colorMod(SDL_Color mod) nothrow @nogc @trusted
    {
        SDL_SetTextureColorMod(ptr,mod.r,mod.g,mod.b);
    }
    @property SDL_Color colorMod() nothrow @nogc @trusted
    {
        SDL_Color r;
        SDL_GetTextureColorMod(ptr,&r.r,&r.g,&r.b);
        return r;
    }
    @property void alphaMod(ubyte mod) nothrow @nogc @trusted
    {
        SDL_SetTextureAlphaMod(ptr,mod);
    }
    @property ubyte alphaMod() nothrow @nogc @trusted
    {
        ubyte r;
        SDL_GetTextureAlphaMod(ptr,&r);
        return r;
    }
    @property void blendMode (SDL_BlendMode mode) nothrow @nogc @trusted
    {
        SDL_SetTextureBlendMode(ptr,mode);
    }
    @property SDL_BlendMode blendMode() nothrow @nogc @trusted
    {
        SDL_BlendMode r;
        SDL_GetTextureBlendMode(ptr,&r);
        return r;
    }
    int update(ref const(SDL_Rect) bounds, const(void)[] pixels, int pitch) nothrow @nogc @trusted
    {
        return SDL_UpdateTexture(ptr,&bounds,pixels.ptr,pitch);
    }
    int lock (ref const(SDL_Rect) bounds, void[] pixels, ref int pitch) nothrow @nogc @trusted
    {
        void *p = pixels.ptr;
        return SDL_LockTexture(ptr,&bounds,&p,&pitch);
    }
    void unlock () nothrow @nogc @trusted
    {
        return SDL_UnlockTexture(ptr);
    }
    int glBindTexture(ref float w, ref float h)
    {
        return SDL_GL_BindTexture(ptr,&w,&h);
    }
    int glUnbindTexture(ref SDLTexture tex)
    {
        return SDL_GL_UnbindTexture(ptr);
    }
    SDL_Texture * ptr;
}

struct SDLRenderer
{    
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
    @property void target( SDLTexture tex) nothrow @nogc @trusted
    {
        SDL_SetRenderTarget(ptr,tex.ptr);
    }
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
            SDL_RenderCopy(ptr,tex.ptr,&src,&dst);
        else 
            SDL_RenderCopyF(ptr,tex.ptr,&src,&dst);
    }
    void copyEx(T) (ref SDLTexture tex, ref const(SDL_Rect) src, ref const(SDL_Rect!T) dst) nothrow @nogc @trusted
    {
        static if (is(T == int))
            SDL_RenderCopyEx(ptr,tex.ptr,&src,&dst);
        else 
            SDL_RenderCopyExF(ptr,tex.ptr,&src,&dst);
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

    import sdl2.c.sdl : 
        SDL_CreateRenderer, SDL_CreateSoftwareRenderer, SDL_GetRenderer,
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
        SDL_DestroyRenderer, SDL_RenderFlush;

    void drawPixel(vec2!short p, SDL_Color c) nothrow @nogc @trusted
    {
        pixelColor(ptr, p.x, p.y, c.packed);
    }
    void drawHLine(vec2!short p, short x2, SDL_Color c) nothrow @nogc @trusted
    {
        hlineColor(ptr,p.x,x2,p.y,c.packed);
    }
    void drawVLine(vec2!short p, short y2, SDL_Color c) nothrow @nogc @trusted
    {
        vlineColor(ptr,p.x,p.y,y2,c.packed);
    }
    void drawRect(vec2!short p0, vec2!short p1, SDL_Color c) nothrow @nogc @trusted
    {
        rectangleColor(ptr,p0.x,p0.y,p1.x,p1.y,c.packed);
    }
    void drawRectRounded(vec2!short p0, vec2!short p1, short rad, SDL_Color c) nothrow @nogc @trusted
    {
        roundedRectangleColor(ptr,p0.x,p0.y,p1.x,p1.y,rad,c.packed);
    }
    void fillRect(vec2!short p0, vec2!short p1, SDL_Color c) nothrow @nogc @trusted
    {
        boxColor(ptr, p0.x, p0.y, p1.x, p1.y, c.packed);
    }
    void fillRectRounded(vec2!short p0, vec2!short p1, short rad, SDL_Color c) nothrow @nogc @trusted
    {
        roundedBoxColor(ptr, p0.x, p0.y, p1.x, p1.y, rad, c.packed);
    }
    void drawLine(vec2!short p0, vec2!short p1, SDL_Color c) nothrow @nogc @trusted
    {
        lineColor(ptr,p0.x,p0.y,p1.x,p1.y,c.packed);
    }
    void drawLineThick(vec2!short p0, vec2!short p1, ubyte width, SDL_Color c) nothrow @nogc @trusted
    {
        thickLineColor(ptr,p0.x,p0.y,p1.x,p1.y,width,c.packed);
    }
    void drawLineAA(vec2!short p0, vec2!short p1, SDL_Color c) nothrow @nogc @trusted
    {
        aalineColor(ptr,p0.x,p0.y,p1.x,p1.y,c.packed);
    }
    void drawCircle(vec2!short p, short radius, SDL_Color c) nothrow @nogc @trusted
    {
        circleColor(ptr,p.x,p.y,radius,c.packed);
    }
    void drawCircleAA(vec2!short p, short radius, SDL_Color c) nothrow @nogc @trusted
    {
        aacircleColor(ptr,p.x,p.y,radius,c.packed);
    }
    void fillCircle(vec2!short p, short radius, SDL_Color c) nothrow @nogc @trusted
    {
        filledCircleColor(ptr,p.x,p.y,radius,c.packed);
    }
    void drawArc(vec2!short p, short radius, short start, short end, SDL_Color c) nothrow @nogc @trusted
    {
        arcColor(ptr,p.x,p.y,radius,start,end,c.packed);
    }
    void drawEllipse(vec2!short p, short r1, short r2, SDL_Color c) nothrow @nogc @trusted
    {
        ellipseColor(ptr,p.x,p.y,r1,r2,c.packed);
    }
    void drawEllipseAA(vec2!short p, short r1, short r2, SDL_Color c) nothrow @nogc @trusted
    {
        aaellipseColor(ptr,p.x,p.y,r1,r2,c.packed);
    }
    void fillEllipse(vec2!short p, short r1, short r2, SDL_Color c) nothrow @nogc @trusted
    {
        filledEllipseColor(ptr,p.x,p.y,r1,r2,c.packed);
    }
    void drawPie(vec2!short p, short r, short start, short end, SDL_Color c) nothrow @nogc @trusted
    {
        pieColor(ptr,p.x,p.y,r,start,end,c.packed);
    }
    void fillPie(vec2!short p, short r, short start, short end, SDL_Color c) nothrow @nogc @trusted
    {
        filledPieColor(ptr,p.x,p.y,r,start,end,c.packed);
    }
    void drawTrigon(vec2!short[3] pts, SDL_Color c) nothrow @nogc @trusted
    {
        trigonColor(ptr,pts[0].x,pts[0].y,pts[1].x,pts[1].y,pts[2].x,pts[2].y,c.packed);
    }
    void drawTrigonAA(vec2!short[3] pts, SDL_Color c) nothrow @nogc @trusted
    {
        aatrigonColor(ptr,pts[0].x,pts[0].y,pts[1].x,pts[1].y,pts[2].x,pts[2].y,c.packed);
    }
    void fillTrigon(vec2!short[3] pts, SDL_Color c) nothrow @nogc @trusted
    {
        filledTrigonColor(ptr,pts[0].x,pts[0].y,pts[1].x,pts[1].y,pts[2].x,pts[2].y,c.packed);
    }

    import sdl2.c.gfx : 
        pixelColor, hlineColor, vlineColor, rectangleColor,
        roundedRectangleColor, boxColor, roundedBoxColor, 
        lineColor, aalineColor, thickLineColor, circleColor, 
        arcColor, aacircleColor, filledCircleColor, ellipseColor,
        pieColor, filledPieColor, trigonColor, aatrigonColor, 
        filledTrigonColor, polygonColor, aapolygonColor, filledPolygonColor, 
        texturedPolygon, bezierColor, aaellipseColor, filledEllipseColor;
    SDL_Renderer * ptr;
}