module sdl2.renderer;

import vectortype;
public import sdl2.c.types : SDL_Rect, SDLRect, SDL_Renderer, SDL_BlendMode,
                             SDL_RendererInfo, SDL_Window, SDL_Surface, SDL_bool,
                             SDL_RendererFlags, SDL_Color, SDL_Texture, SDL_Point,
                             SDLPoint, SDL_TextureAccess, SDL_Pair;
import std.array : staticArray;
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

/// helper structure for querying texture
struct SDLTextureQuery
{
    @disable this(this);
    uint format;
    int access;
    int w;
    int h;
    this(ref SDLTexture tex) @trusted @nogc nothrow pure
    {
        SDL_QueryTexture(tex.ptr, &format, &access, &w, &h);
    }
        import sdl2.c.sdl : SDL_QueryTexture;
}

struct SDLTextureLock(T)
{
    @disable this(this);
    T[] pixels;
    int pitch;
    SDL_Texture * ptr;
    uint format;
    
    this(ref SDLTexture tex) @trusted @nogc nothrow 
    {
        int w; int h;
        SDL_QueryTexture(tex.ptr, &format, null, &w, &h);
        void *p ;
        this.ptr = tex.ptr;
        SDL_LockTexture(ptr,null,&p,&pitch);
        pixels = cast(T[])p[0..w*h*T.sizeof];
    }
    this(ref SDLTexture tex, ref const(SDL_Rect) r) @trusted @nogc nothrow 
    {
        void *p = pixels.ptr;
        SDL_LockTexture(tex.ptr,&r,&p,&pitch);
    }
    ~this() @trusted @nogc nothrow pure
    {
        // assert(0,"lets see when this happens");
        SDL_UnlockTexture(ptr);
    }
    import sdl2.c.sdl : SDL_LockTexture, SDL_UnlockTexture, SDL_QueryTexture;;
}


/// wraps SDL_Texture to a more D friendly object
/// A structure that contains an efficient, driver-specific representation of pixel data.
struct SDLTexture 
{
    /// create a texture for a rendering context. 
    /// params:
    ///     renderer = the rendering context
    ///     format = one of the enumerated values in SDL_PixelFormatEnum
    ///     access = one of the enumerated values in SDL_TextureAccess
    ///     w = the width of the texture in pixels
    ///     h = the height of the texture in pixels  
    this(ref SDLRenderer renderer, uint format, SDL_TextureAccess access, int w, int h) nothrow @nogc @trusted
    {
        ptr = SDL_CreateTexture(renderer.ptr,format,access,w,h);
    }

    /// create texture from surface
    /// params:
    ///     renderer = the rendering context
    ///     surface = the SDL_Surface structure containing pixel data used to fill the texture
    this(ref SDLRenderer renderer, ref SDLSurface s) nothrow @nogc @trusted
    {
        ptr = SDL_CreateTextureFromSurface(renderer.ptr,s.ptr);
    }

    /// cleans up texture when we are done with it
    ~this() nothrow @nogc @trusted
    {
        SDL_DestroyTexture(ptr);
    }

    // int query (ref uint format, ref int access, ref int w, ref int h) nothrow @nogc @trusted
    // {
    //     return SDL_QueryTexture(ptr, &format, &access, &w, &h);
    // }
    // @property uint format()
    // {
    //     uint f;
    //     SDL_QueryTexture(ptr, &f, null, null, null);
    //     return f;
    // }
    // @property int access()
    // {
    //     int a;
    //     SDL_QueryTexture(ptr, null, &a, null, null);
    //     return a;
    // }
    // @property vec2!int size()
    // {
    //     vec2!int s;
    //     SDL_QueryTexture(ptr, null, null, &s.w, &s.h);
    //     return s;
    // }
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
    int update(const(void)[] pixels, int pitch) nothrow @nogc @trusted
    {
        return SDL_UpdateTexture(ptr,null,pixels.ptr,pitch);
    }
    // int lock (in const(SDL_Rect) bounds, out void[] pixels, out int pitch) nothrow @nogc @trusted
    // {
    //     void *p = pixels.ptr;
    //     return SDL_LockTexture(ptr,&bounds,&p,&pitch);
    // }
    // int lock (void[] pixels, ref int pitch) nothrow @nogc @trusted
    // {
    //     void *p = pixels.ptr;
    //     return SDL_LockTexture(ptr,null,&p,&pitch);
    // }
    // void unlock () nothrow @nogc @trusted
    // {
    //     return SDL_UnlockTexture(ptr);
    // }
    int glBindTexture(ref float w, ref float h)
    {
        return SDL_GL_BindTexture(ptr,&w,&h);
    }
    int glUnbindTexture(ref SDLTexture tex)
    {
        return SDL_GL_UnbindTexture(ptr);
    }
    SDL_Texture * ptr;
    import sdl2.c.sdl : SDL_CreateTexture, SDL_CreateTextureFromSurface, 
                    SDL_QueryTexture, SDL_SetTextureColorMod, SDL_GetTextureColorMod,
                    SDL_SetTextureAlphaMod, SDL_GetTextureAlphaMod, SDL_SetTextureBlendMode,
                    SDL_GetTextureBlendMode, SDL_UpdateTexture, SDL_UpdateYUVTexture,
                    SDL_LockTexture, SDL_UnlockTexture, SDL_DestroyTexture,
                    SDL_GL_BindTexture, SDL_GL_UnbindTexture;
}

struct SDLRendererInfo
{
    @disable this(this);
    SDL_RendererInfo info;
    this(SDLRenderer renderer)
    {
        SDL_GetRendererInfo(renderer.ptr,&info);
    }
    void updateWith(SDLRenderer renderer)
    {
        SDL_GetRendererInfo(renderer.ptr,&info);
    }
    alias info this;
    import sdl2.c.sdl : SDL_GetRendererInfo;
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
    @property bool isNull() nothrow @nogc @trusted { return (ptr == null); }
    // int info(ref SDL_RendererInfo info) nothrow @nogc @trusted
    // {
    //     return SDL_GetRendererInfo(ptr,&info);
    // }

    @property bool isTargetSupported() nothrow @nogc @trusted
    {
        return cast(bool) SDL_RenderTargetSupported(ptr);
    }
    import std.typecons : NullableRef;
    @property void target( SDLTexture tex) nothrow @nogc @trusted
    {
        SDL_SetRenderTarget(ptr,tex.ptr);
    }
    @property void target(typeof(null) n)
    {
        SDL_SetRenderTarget(ptr,n);
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
    void drawPoint(T) (const(SDLPoint!T) pt) nothrow @nogc @trusted
        if (is(T == float) || is(T == int))
    {
        static if (is(T == int))
            SDL_RenderDrawPoint(ptr,pt.x,pt.y);
        else 
            SDL_RenderDrawPointF(ptr,pt.x,pt.y);
    }
    void drawPoints(T)(const(SDLPoint!T)[] pts) nothrow @nogc @trusted
        if (is(T == float) || is(T == int))
    {
        static if (is(T == int))
            SDL_RenderDrawPoints(ptr,pts.ptr,pts.length);
        else 
            SDL_RenderDrawPointsF(ptr,pts.ptr,pts.length);
    }
    void drawLine(T) (const(SDLPoint!T) p1, const(SDLPoint!T) p2) nothrow @nogc @trusted
        if (is(T == float) || is(T == int))
    {
        static if (is(T == int))
            SDL_RenderDrawLine(ptr,p1.x,p1.y,p2.x,p2.y);
        else 
            SDL_RenderDrawLineF(ptr,p1.x,p1.y,p2.x,p2.y);
    }

    void drawLines(T) (const(SDLPoint!T[]) pts) nothrow @nogc @trusted
        if (is(T == float) || is(T == int))
    {
        static if (is(T == int))
            SDL_RenderDrawLines(ptr,pts.ptr,cast(int) pts.length);
        else
            SDL_RenderDrawLinesF(ptr,pts.ptr,cast(int) pts.length);
    }

    void drawRect(T) (auto ref const(SDLRect!T) r) nothrow @nogc @trusted
        if (is(T == float) || is(T == int))
    {
        static if (is(T == int))
            SDL_RenderDrawRect(ptr,&r);
        else
            SDL_RenderDrawRectF(ptr,&r);
    }
    void drawRect(T) (const(SDLPoint!T) p1, const(SDLPoint!T) p2)
    {
        SDLRect!T r = SDLRect (p1.x, p1.y, p2.x-p1.x, p2.y-p1.y);
        static if (is(T == int))
            SDL_RenderDrawRect(ptr,&r);
        else
            SDL_RenderDrawRectF(ptr,&r);
    }
    void drawRects(T) (const(SDLRect!T)[] r) nothrow @nogc @trusted
        if (is(T == float) || is(T == int))
    {
        static if (is(T == int))
            SDL_RenderDrawRects(ptr,r.ptr,r.length);
        else 
            SDL_RenderDrawRectsF(ptr,r.ptr,r.length);
    }
    void fillRect(T) (ref const(SDLRect!T) r) nothrow @nogc @trusted
        if (is(T == float) || is(T == int))
    {
        static if (is(T == int))
            SDL_RenderFillRect(ptr,&r);
        else 
            SDL_RenderFillRectF(ptr,&r);
    }
    void fillRect(T) (const(SDLPoint!T) p1, const(SDLPoint!T) p2) nothrow @nogc @trusted
        if (is(T == float) || is(T == int))
    {
        SDLRect!T r = SDL_Rect(p1.x, p1.y, p2.x - p1.x, p2.y - p1.y);
        static if (is(T == int))
            SDL_RenderFillRect(ptr,&r);
        else 
            SDL_RenderFillRectF(ptr,&r);
    }
    void fillRects(T) (const(SDLRect!T)[] r) nothrow @nogc @trusted
        if (is(T == float) || is(T == int))
    {
        static if (is(T == int))
            SDL_RenderFillRects(ptr,r.ptr,r.length);
        else
            SDL_RenderFillRectsF(ptr,r.ptr,r.length);
    }
    void copy(T) (ref SDLTexture tex, ref const(SDLRect!T) dst) nothrow @nogc @trusted
        if (is(T == float) || is(T == int))
    {
       static if (is(T == int)) 
            SDL_RenderCopy(ptr,tex.ptr,null,&dst);
        else 
            SDL_RenderCopyF(ptr,tex.ptr,null,&dst);
    }
    void copy(T) (ref SDLTexture tex, ref const(SDLRect!T) src, ref const(SDLRect!T) dst) nothrow @nogc @trusted
        if (is(T == float) || is(T == int))
    {
       static if (is(T == int)) 
            SDL_RenderCopy(ptr,tex.ptr,&src,&dst);
        else 
            SDL_RenderCopyF(ptr,tex.ptr,&src,&dst);
    }
    void copyEx(T) (ref SDLTexture tex, ref const(SDLRect!T) src, ref const(SDLRect!T) dst) nothrow @nogc @trusted
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


    enum  DEFAULT_ELLIPSE_OVERSCAN	= 4;
    enum AAlevels = 256;
    enum AAbits = 8;

    pragma(inline,true) void drawHLine(T)(SDLPoint!T point, T endX) nothrow @nogc @trusted
    {
        drawLine!T(point,SDL_Pair(point.x+endX,point.y));
    } 
    pragma(inline,true) void drawVLine(T)(SDLPoint!T point, T endY) nothrow @nogc @trusted
    {
        drawLine!T(point,SDL_Pair(point.x,point.y+endY));
    }
    pragma(inline,true) void drawCircle(SDL_Point point, int radius) nothrow @nogc @trusted
    {
        _ellipse(point,SDL_Pair(radius,radius),false);
    }
    pragma(inline,true) void fillCircle(SDL_Point point, int radius) nothrow @nogc @trusted
    {
        _ellipse(point,SDL_Pair(radius,radius),true);
    }
    pragma(inline,true) void drawEllipse(SDL_Point point, SDL_Pair radii) nothrow @nogc @trusted
    {
        _ellipse(point,radii,false);
    }
    pragma(inline,true) void fillEllipse(SDL_Point point, SDL_Pair radii) nothrow @nogc @trusted
    {
        _ellipse(point,radii,true);
    }
    pragma(inline,true) void drawPie(SDL_Point point, int radius, int start, int end) nothrow @nogc @trusted
    {
        _pie(point,radius,start,end,false);
    }
    pragma(inline,true) void fillPie(SDL_Point point, int radius, int start, int end) nothrow @nogc @trusted
    {
        _pie(point,radius,start,end,true);
    }


    private void _pie(SDL_Point p, int rad, int start, int end, bool filled) nothrow @nogc @trusted
    in { assert(rad>0);}
    body
    {
        import sdl2.memory : sdlAllocator, makeArray, dispose;
        import std.math : PI,ceil,cos,sin; alias π = PI;
        import std.algorithm.comparison : min;
        start %= 360;
        end %= 360;

        if (rad == 0) return drawPoint(p);
        double radius = cast(double) rad;
        auto ΔΘ = 3.0 / radius;
        auto Θstart = cast(double) start * (2.0*π/360.0);
        auto Θend = cast(double) end * (2.0*π/360.0);
        if (start > end ) Θend += (2.0*π);

        auto numPoints = cast(int) ceil((Θend - Θstart) / ΔΘ) + 3;
        
        if (numPoints == 3) 
        {
            auto p2 = SDL_Point( p.x + cast(int)(cos(Θstart)*radius), p.y + cast(int)(sin(Θstart)*radius));
            return drawLine(p,p2);
        }
        
        SDL_Point[] vertices = sdlAllocator.makeArray!SDL_Point(numPoints);
        scope(exit) sdlAllocator.dispose(vertices);
        
        vertices[0] = p; 
        auto Θ = Θstart;
        foreach (ref vertex; vertices[1..$-1])
        {
            vertex = SDL_Point(p.x + cast(int)(radius * cos(Θ)), p.y + cast(int)(radius * sin(Θ)));
            Θ = min(Θ+ΔΘ,Θend);
        }
        vertices[$-1] = p;

        if (filled)  _fillPolygon(vertices);
        else drawLines(vertices);
        
    }

    private void _fillPolygon( SDL_Point[] verticies) nothrow @nogc @trusted
    in { assert(verticies.length >= 4); }
    body
    {       
        import sdl2.memory : sdlAllocator, makeArray, dispose;

        // worst case is a crown shape a horizantal line will intersect it 
        // in n - 1 cases (-1 because we are doubling up the last point)
        auto buffer = sdlAllocator.makeArray!int(verticies.length - 2); 
        scope(exit) sdlAllocator.dispose(buffer);
 
        immutable c = this.color;
        this.blendMode = (c.a == 255) ? SDL_BlendMode.NONE : SDL_BlendMode.BLEND;
        
        // calculate bounds in height
        import std.algorithm.searching : minElement, maxElement;
        immutable int minY = verticies.minElement!"a.y".y;
        immutable int maxY = verticies.maxElement!"a.y".y;
        
        auto intercepts = buffer[];

        foreach(y; minY .. maxY)
        {
            intercepts = buffer [0..0];
            // find all the places that the outline
            // intercepts with a horizontal line
            foreach(i; 1..verticies.length)
            {
                if (verticies[i-1].y == verticies[i].y) continue;
                // v2 is always the vertex with the greater y value
                immutable v1 = 
                    (verticies[i-1].y > verticies[i].y) ? 
                        verticies[i] : 
                        verticies[i-1];
                immutable v2 = 
                    (verticies[i-1].y > verticies[i].y) ? 
                        verticies[i-1] : 
                        verticies[i];

                if (((y >= v1.y)&&(y < v2.y)) || 
                    ((y == maxY) && (y > v1.y) && (y <= v2.y)))
                {
                    intercepts = buffer[0..intercepts.length+1];
                    // TODO: this line is somehow doing integer math on 
                    // the points to figure out an x position need to 
                    // figure out exactly what it does
                    intercepts[$-1]= 
                        ((0x00010000 * (y - v1.y)) / (v2.y - v1.y)) * (v2.x - v1.x) + 
                        (0x00010000 * v1.x); 
                }
            }
            import std.algorithm.sorting : sort;
            intercepts.sort();
            
            // intercepts come in pairs (because we sorted the array)
            // draw a horizantal line between each intercept pair 
            for (int i = 0; i < intercepts.length; i+=2)
            {
                auto xa = intercepts[i] + 1;
                xa = (xa >> 16) + ((xa & 32_768) >> 15);
                auto xb = intercepts[i+1] - 1;
                xb = (xb >> 16) + ((xb & 32_768) >> 15);
                drawLine(SDL_Point(xa,y), SDL_Point(xb,y));
            }
        }
    }

    SDL_Color withAlphaWeight(SDL_Color c, int weight) nothrow @nogc @trusted
    {
        import std.algorithm.comparison : min;
        int a = min(((cast(int)c.a*weight) >> 8),255);
        return SDL_Color (c.r, c.g, c.b, cast(ubyte)(a & 0x000000ff));
        
    }

    private void drawLineAA(SDL_Point p1, SDL_Point p2, int drawEndpoint) nothrow @nogc @trusted
    {
        // p2 should be higher on the screen than p1
        // swap them if this is not the case
        if (p1.y > p2.y)
        {
            SDL_Point tmp = p1;
            p1 = p2;
            p2 = tmp;
        }
        
        // draw non antialiased lines for horizontal
        // vertical or 45° diagonal lines 
        SDL_Pair distance; distance[] = p2[] - p1[];
        if (distance.x == 0)
        {
            if (drawEndpoint || distance.y > 0) return drawLine(p1,p2);
            else return drawPoint(p1);
        }
        else if (distance.y == 0)
        {
            if (drawEndpoint || distance.x > 0) return drawLine(p1,p2);
            else return drawPoint(p1);
        }
        else if (distance.x == distance.y && drawEndpoint) return drawLine(p1,p2);

        
        immutable int xdir = (distance.x >= 0) ? 1 : -1;
        distance.x *= xdir;
        int error = 0;
        immutable int intshift = 32 - AAbits;
        immutable int compMask = AAlevels - 1;

        drawPoint(p1);

        SDL_Color c = this.color;

        if (distance.y > distance.x)
        {
            int errorAdjustment = ((distance.x << 16) / distance.y) << 16;
            auto xOpXDir = p1.x + xdir;
            while (--distance.y)
            {
                auto tmp = error;
                error += errorAdjustment;
                if (error <= tmp)
                {
                    p1.x = xOpXDir;
                    xOpXDir += xdir;
                }
                p1.y++;
                auto weight = (error >> intshift) & 255;
                this.color = withAlphaWeight(c,255-weight);
                drawPoint(p1);
                this.color = withAlphaWeight(c,weight);
                drawPoint(SDL_Point(xOpXDir,p1.y));
            }
        }
        else 
        {
            auto errorAdjustment = ((distance.y << 16) / distance.x) << 16;
            while (--distance.x)
            {
                auto tmp = error;
                error += errorAdjustment;
                if (error <= tmp) { p1.y++; }
                p1.x += xdir;
                auto weight = (error >> intshift) & 255;
                this.color = withAlphaWeight(c,255-weight);
                drawPoint(p1);
                this.color = withAlphaWeight(c,weight);
                drawPoint(SDL_Point(p1.x, p1.y+1));
            }
        }
        this.color = c;
        if (drawEndpoint)
        {
            drawPoint(p2);
        }
    }

    private void _drawQuadrants (const SDL_Point center, const SDL_Pair distance, const int filled) nothrow @nogc @trusted
    {
        if(distance.x == 0)
        {
            if (distance.y == 0) return drawPoint(center);
            else 
            {
                immutable SDL_Point offset = {0,distance.y};
                immutable p1 = center - offset;
                immutable p2 = center + offset;

                if (filled) drawLine(p1,p2);
                else { drawPoint(p1); drawPoint(p2); }
            }
        }
        else
        {
            immutable p2 = center + distance;
            immutable p3 = center - distance;
            immutable p1 = SDL_Point(p2.x,p3.y);
            immutable p4 = SDL_Point(p3.x,p2.y);

            if(filled)
            {
                drawLine(p1,p2);
                drawLine(p3,p4);
            }
            else 
            {
                drawPoint(p2);
                drawPoint(p4);
                drawPoint(p1);
                drawPoint(p3);
            }
        }
    }

    private void _ellipse(SDL_Point center, SDL_Pair radius,bool filled) nothrow @nogc @trusted
    {
        immutable SDL_Point rsquared = radius^^2;
        immutable SDL_Point direction = {1,-1};
        SDL_Point p = {0, radius.y};
        SDL_Point Δ = { 2*rsquared.y*p.x, 2*radius.y*radius.x*p.y };
        
        int decision = rsquared.y - (rsquared.x*radius.y) + (rsquared.x/4);
        while(Δ.x < Δ.y)
        {
            _drawQuadrants(center,p,filled);
            if (Δ.x < 0)
            {
                p.x++;
                Δ.x += 2 * rsquared.y;
                decision +=  rsquared.y + Δ.x;
            }
            else 
            {
                p += direction;
                Δ += direction * rsquared * 2;
                decision += Δ.x - Δ.y + rsquared.y;
            }
        }
        
        decision = cast(int)(rsquared.y * ((p.x+0.5)^^2)) + (rsquared.x * ((p.y-1)^^2)) - (radius.y^^4);
        while (p.y >= 0)
        {
            _drawQuadrants(center,p,filled);
            if (decision > 0)
            {
                p.y--;
                Δ.y -= 2 * rsquared.x;
                decision += rsquared.x - Δ.y;
            }
            else 
            {
                p += direction;
                Δ += direction * rsquared * 2; 
                decision += Δ.x - Δ.y + rsquared.x;
            }
        }
    }

    // private void _ellipse(SDL_Point pos, SDL_Pair radius, int filled) nothrow @nogc @trusted
    // in { assert(radius.x >= 0 && radius.y >= 0);  }
    // body
    // {
    //     if (radius.x == 0)
    //     {
    //         if (radius.y == 0) return drawPoint(pos);
    //         return drawLine(SDL_Point(pos.x,pos.y-radius.y), SDL_Point(pos.x,pos.y+radius.y));
    //     }
    //     else if (radius.y == 0) return drawLine(SDL_Point(pos.x-radius.x,pos.y), SDL_Point(pos.x+radius.x,pos.y));

    //     int overscan;
    //     if (radius.x >= 512 || radius.y >= 512) overscan = DEFAULT_ELLIPSE_OVERSCAN / 4;
    //     else if (radius.x >= 256 || radius.y >= 256) overscan = DEFAULT_ELLIPSE_OVERSCAN / 2;
    //     else overscan = DEFAULT_ELLIPSE_OVERSCAN / 1; 

    //     auto screen = SDL_Pair(0,radius.y); 
    //     auto  old = screen;
    //     _drawQuadrants(pos,SDL_Pair(0,radius.y),filled);
    //     radius[] *= overscan;
    //     immutable SDL_Pair r2 = radius * radius;
    //     immutable SDL_Pair r22 = r2 * r2;
    //     SDL_Pair current = {0, radius.y};
    //     SDL_Pair Δ = {0, r22.x*current.y};

    //     int error = r2.y - r2.x * radius.y + r2.x / 4;
    //     while (Δ.x <= Δ.y)
    //     {
    //         current.x++;
    //         Δ.x += r22.y;

    //         error += Δ.x + r2.y;
    //         if (error >= 0)
    //         {
    //             current.y--;
    //             Δ.y -= r22.x;
    //             error -= Δ.y;
    //         }

    //         screen[] = current[] / overscan;
    //         if ( (screen.x != old.x && screen.y == old.y) || (screen.x != old.x && screen.y != old.y) )
    //         {
    //             _drawQuadrants(pos,screen,filled);
    //             old = screen;
    //         }
    //     }

    //     if (current.y > 0)
    //     {
    //         error = r2.y * current.x * (current.x + 1) + ((r2.y + 3) / 4) + r2.x * (current.y-1) * (current.y-1) - r2.x * r2.y;
    //         while (current.y > 0)
    //         {
    //             current.y--;
    //             Δ.y -= r22.x;
    //             error += (r2.x - Δ.y);

    //             if (error <= 0)
    //             {
    //                 current.x++;
    //                 Δ.x += r22.y;
    //                 error += Δ.x;
    //             }
    //             screen[] = current[] / overscan;
    //             if ( (screen.x != old.x && screen.y == old.y) || (screen.x != old.x && screen.y != old.y) )
    //             {
    //                 old.y--;
    //                 for (; old.y >= screen.y; old.y--)
    //                 {
    //                     _drawQuadrants(pos, SDL_Point(screen.x,old.y), filled);
    //                     if (filled) old.y = screen.y - 1;
    //                 }
    //                 old[] = screen[];
    //             }
    //         }
    //         if (!filled)
    //         {
    //             old.y--;
    //             for (; old.y >= 0; old.y--)
    //             {
    //                 _drawQuadrants(pos,SDL_Point(screen.x, old.y),filled);
    //             }
    //         }
    //     }


    // }



    // void drawRectRounded(vec2!short p0, vec2!short p1, short rad, SDL_Color c) nothrow @nogc @trusted
    // {
    //     roundedRectangleColor(ptr,p0.x,p0.y,p1.x,p1.y,rad,c.packed);
    // }

    // void fillRectRounded(vec2!short p0, vec2!short p1, short rad, SDL_Color c) nothrow @nogc @trusted
    // {
    //     roundedBoxColor(ptr, p0.x, p0.y, p1.x, p1.y, rad, c.packed);
    // }
 
    // void drawLineThick(vec2!short p0, vec2!short p1, ubyte width, SDL_Color c) nothrow @nogc @trusted
    // {
    //     thickLineColor(ptr,p0.x,p0.y,p1.x,p1.y,width,c.packed);
    // }
    // void drawLineAA(vec2!short p0, vec2!short p1, SDL_Color c) nothrow @nogc @trusted
    // {
    //     aalineColor(ptr,p0.x,p0.y,p1.x,p1.y,c.packed);
    // }

    // void drawCircleAA(vec2!short p, short radius, SDL_Color c) nothrow @nogc @trusted
    // {
    //     aacircleColor(ptr,p.x,p.y,radius,c.packed);
    // }

    // void drawArc(vec2!short p, short radius, short start, short end, SDL_Color c) nothrow @nogc @trusted
    // {
    //     arcColor(ptr,p.x,p.y,radius,start,end,c.packed);
    // }
 
    // void drawEllipseAA(vec2!short p, short r1, short r2, SDL_Color c) nothrow @nogc @trusted
    // {
    //     aaellipseColor(ptr,p.x,p.y,r1,r2,c.packed);
    // }

    // void drawTrigon(vec2!short[3] pts, SDL_Color c) nothrow @nogc @trusted
    // {
    //     trigonColor(ptr,pts[0].x,pts[0].y,pts[1].x,pts[1].y,pts[2].x,pts[2].y,c.packed);
    // }
    // void drawTrigonAA(vec2!short[3] pts, SDL_Color c) nothrow @nogc @trusted
    // {
    //     aatrigonColor(ptr,pts[0].x,pts[0].y,pts[1].x,pts[1].y,pts[2].x,pts[2].y,c.packed);
    // }
    // void fillTrigon(vec2!short[3] pts, SDL_Color c) nothrow @nogc @trusted
    // {
    //     filledTrigonColor(ptr,pts[0].x,pts[0].y,pts[1].x,pts[1].y,pts[2].x,pts[2].y,c.packed);
    // }

    SDL_Renderer * ptr;
}