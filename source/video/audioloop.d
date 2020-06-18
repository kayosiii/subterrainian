module video.audioloop;

/// maps a rectangular image of a waveform 
/// into an annullis shape (2D donut from the top)
struct AudioAnnulusMapper(T)
if ( is(T==ubyte) || is(T==ushort) || is(T==ubyte[3]) || is(T==uint))
{
    /// create a ubyte map of the pixels of a source image mapped to an Annulis
    /// and a rle encoded map of the runs of pixels to blit
    this(ref SDLSurface src, int size, float iRatio=0.125, float oRatio=0.375) @nogc @safe nothrow       
    in { assert(T.sizeof == src.format.BytesPerPixel,"does not match");}
    body
    {
        this.w = size;
        this.h = size;
        immutable center = size/2;
        auto rInner = cast(int)(size*iRatio);
        auto rSize = cast(int)(size*oRatio);
        
        srcPx =  src.pixels!uint;

        map = memory.allocator.makeArray!uint(size^^2);
        offsetMap = memory.allocator.makeArray!(int[4])(this.h,[-1,-1,-1,-1]);

        foreach (long y, ref row; offsetMap)
        {
            auto run = 0;
            auto nPixels = 0;
            foreach (long x; 0..w)
            {
                immutable SDL_FPair offset = { center - x, y - center };
                immutable Θ = atan2( offset.y, offset.x );
                SDL_FPoint pos = {((src.w-1)*(Θ+π)/(π*2.0)), 0 };
                pos.y = (offset.y == 0) ?
                    ((abs(offset.x)-rInner)*src.h/rSize) - 0.5 :
                    ((offset.y/sin(Θ)-rInner) * src.h/rSize) - 0.5;

                if ( 0 <= pos.y && pos.y < src.h )
                {
                    map[y*w + x] = cast(int)(pos.y)*src.w + cast(int)(pos.x);
                   
                    if (nPixels <= 0)
                    {
                        row[run] = -nPixels;
                        run++;
                        nPixels = 0;
                    }
                    nPixels++;
                }
                else 
                {
                    // last position was a hit
                    // this is the first in a run of misses 
                    if (nPixels > 0)
                    {
                        row[run] = nPixels;
                        run++;
                        nPixels = 0;
                    }
                    //register a miss
                    nPixels--;
                }
            }
            // last x value was a hit
            // record another run 
            if (nPixels > 0) 
            {
                row[run] = nPixels;
                run++;
            } 
            
            // convert length of runs to offsets
            row[1] += row[0];
            row[2] += row[1];
            row[3] += row[2];
        }
    }
 
    ~this() @trusted @nogc nothrow 
    {
        memory.allocator.dispose(offsetMap);
        memory.allocator.dispose(map);
    }
    /// copy raw pixel data into a texture
    /// that can be placed by the renderer
    bool optimisedBlit(ref SDLTexture tex) @trusted @nogc nothrow 
    {        
        uint[] mapRun;
        T[] outRun;

        auto texLock = SDLTextureLock!uint(tex);
        
        foreach (y, ref offset; offsetMap)
        {
            if(offset[0] < 0) 
            {
               texLock.pixels[0..(y+1)*w] =bgColorPacked;
            }
            if(offset[0] < 0) continue;
            mapRun = map[y*w+offset[0]..y*w+offset[1]];
            outRun = texLock.pixels[y*w+offset[0]..y*w+offset[1]];
            foreach(i, idx; mapRun) outRun[i] = srcPx[idx];

            if(offset[2] < offset[1]) continue;
            mapRun = map[y*w+offset[2]..y*w+offset[3]];
            outRun = texLock.pixels[y*w+offset[2]..y*w+offset[3]];
            foreach(i, idx; mapRun) outRun[i] = srcPx[idx];
        }
        return false;
    }

    T bgColorPacked;
    T[] srcPx = void;
    uint[] map = void;
    int[4][] offsetMap = void;
    immutable int bpp = void;
    immutable int w = void;
    immutable int h = void;

    import sdl2.c.types : SDL_Pair, SDL_FPair, SDL_Point, SDL_FPoint, SDL_PixelFormatEnum;
    import sdl2.surface;

    import sdl2.renderer : SDLTexture, SDLTextureQuery, SDLTextureLock;
    import vectortype;
    import memory;
    import std.math: PI, sin, atan2, abs, round;
    // import core.stdc.math : atan2;
    alias π = PI;
}

/// draws a representantion of the audio data of a loop 
/// to the screen
struct AudioLoopDisplay
{
    shared static this()  @nogc @safe nothrow
    {
        ampMax = cast(int)OCY*15;
        loopMultiplier = cast(int)OCY*20;
        pieMultiplier = cast(int)OCX*20;
        
    }
    @disable this();
    this(ref SDLRenderer renderer, SDL_Point p, int sz) @nogc @trusted nothrow
    {
        rect = SDL_Rect(p.x, p.y, sz, sz);
        if (this.renderer.isNull)
        {
            this.renderer = renderer;
            loopRect = SDLSurface(0,cast(int)OCX*640,cast(int)OCY*60, 32, SDL_PixelFormatEnum.ARGB8888);
            rectTex = SDLTexture(renderer,loopRect.format.format,SDL_TextureAccess.STREAMING,loopRect.w,loopRect.h);
            loopTex = SDLTexture(renderer,loopRect.format.format,SDL_TextureAccess.STREAMING,rect.w,rect.h);
            // int rInner = cast(int)(rect.w*0.13);
            // int rSize = cast(int)(rect.w*0.5)-rInner;
            emplace(&loopMap,loopRect,sz);
        }
        
    }


    void draw (float lvol, const(SDL_Color[4]) loopColors, ubyte colorMultiplier) @nogc @safe nothrow
    {
        const originalColor = renderer.color;
        scope(exit) renderer.color = originalColor;
        
        auto aux = loops.getLoopAuxData(id);
        if (aux.peaks.length == 0) return;

        loops.lock();
        scope(exit) loops.unlock();

        SDL_Color color;
        color[] = loopColors[0][]*cast(ubyte)loopMultiplier;
        loopRect.fill(color);

        chunk = cast(size_t)(aux.pos / filesystem.loopAuxDataChunkSize);
        assert(chunk < aux.peaks.length,"chunk is too late");
        
        if (chunk != lastChunk)
        {
            currentPeak = (chunk > lastChunk) ? 
                 aux.peaks[lastChunk..chunk].maxElement * peakMultiplier + peakBase : 
                  max ( aux.peaks[lastChunk..$].maxElement, aux.peaks[0..chunk+1].maxElement ) * peakMultiplier + peakBase;
            oldPeak = currentPeak;
            lastChunk = chunk;
        } else { currentPeak = oldPeak; } // still on the same current peak value use precalculated version

        auto aMultiplier = lvol * this.vol * loopMultiplier * currentPeak;
        auto stepX = max(cast(float)loopRect.w / cast(float)aux.peaks.length,1.0);
        auto pos = -1.0 * cast(float)(currentPeak * stepX);
        if (pos < 0.0) pos += cast(float)loopRect.w;
        int midY = loopRect.h/2;
        SDL_Rect r;
        foreach (i, peak; aux.peaks)
        {
            pos += stepX;
            if (pos > loopRect.w) pos = 0.0;

            int rx = cast(int) pos;
            int rw = min(cast(int)floor(pos+stepX),loopRect.w)-rx;
            int amp = min(cast(int)fabs(peak*aMultiplier),ampMax);
            auto peakY = aux.averages[i]/(amp^^2 + 0.00000001)*2; //float.epsilon
            color=lerp(loopColors[1],loopColors[2],peakY);
            r = SDL_Rect(rx,midY-amp,rw,amp*2);
            loopRect.fillRect ( r,color);
        }

        auto texLock = SDLTextureLock!uint(rectTex);
        auto srcPx = loopRect.pixels!uint;
        texLock.pixels[] = srcPx[];
        destroy(texLock);
        r = SDL_Rect(200,200,640,60);
        renderer.copy(rectTex, r);

        SDL_Pair disp = rect.xy;
        SDL_Pair half = {xy:[loopMap.w/2,loopMap.h/2]};
        loopMap.optimisedBlit(loopTex);
        renderer.copy(loopTex,rect);
        renderer.drawCircle(disp+half,half.x);
        auto pieRadius = clamp(cast(int)(lvol*pieMultiplier*currentPeak),5,70); 
        color = loopColors[3] * colorMultiplier;
        color.a = 127;
        renderer.fillPie(disp+half, pieRadius, 0, cast(int)(360*aux.pos));

        auto magbar =  cast(int)(loopMap.w*0.9/2.0*aux.triggerVolume);
        auto offset = SDL_Pair(magbar,half.y/5);
        renderer.color = SDL_Color (cast(ubyte)(loopColors[3].r*colorMultiplier),0,0,127);
        renderer.fillRect(disp+half-offset, disp+half+offset);
        magbar = cast(int)((loopMap.w*250.0-1.0)*colorMultiplier);
        renderer.fillRect(disp+half+SDL_Pair(0,half.y/4), disp+half+SDL_Pair(magbar,half.y/2));

        // if (aux.status == LoopStatus.OverDubbing)
        //     drawText(mainfont,"0",disp+half,textColor);{x:magbar;y:(half.y/2);}
        
        // if (showText) 
        // {
        //     if(aux.isBeingRenamed)
        //     {

        //     }
        //     else 
        //     {
        //         drawText(smallfont,aux.name,disp+SDL_Point(0,full.y),TextColor2);
        //         //show last recorded loop              
        //     }
        // }
    }

  private
  {
    int id;
    float vol = 0.25;
    size_t chunk;
    size_t lastChunk;
    jack_default_audio_sample_t currentPeak, oldPeak = peakBase;
    static AudioAnnulusMapper!uint loopMap;
    static SDLRenderer renderer;
    static SDLTexture loopTex;
    static SDLSurface loopRect;
    static SDLTexture rectTex;
    immutable static SDL_Color textColor = {0xFF, 0x50, 0x20, 0};
    immutable static SDL_Color textColor2 = {0xEF, 0xAF, 0xFF, 0};
    immutable static SDL_Color cursorColor = {0xEF, 0x11, 0x11, 0};
    immutable static SDL_Color[4] selColor = 
        [{ 0xF9, 0xE6, 0x13, 0 }, 
         { 0x62, 0x62, 0x62, 0 },
         { 0xFF, 0xFF, 0xFF, 0 },
         { 0xE0, 0xDA, 0xD5, 0 }];
    immutable static float peakMultiplier = 2.0;
    immutable static float peakBase = 0.5;
    immutable static int ampMax;
    immutable static int loopMultiplier;
    immutable static int pieMultiplier;
    SDL_Rect rect;
  }
    import std.math : fabs,floor;
    import std.conv : emplace;
    import std.algorithm.searching : maxElement;
    import std.algorithm.comparison : max, min,clamp;
    import sdl2.surface : SDLSurface, SDL_PixelFormatEnum, SDL_Rect;
    import sdl2.renderer : SDL_Color, SDLTexture, SDLRenderer, SDL_TextureAccess, SDL_Point, SDL_Pair,  SDLTextureLock;
    import jack.c.types : jack_default_audio_sample_t;
    import config : OCX, OCY;
    import tmp : lerp;
    import loops,filesystem;
}