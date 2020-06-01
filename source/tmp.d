// module tmp;

// import nogc.exception : enforce;
// import memory;
// import vectortype;




// struct Smoother(T)
// {
//     private 
//     { 
//         T v; 
//         T tv;
//         T Δv;
//         T vmax;
//         T vmin;
//         T freq;
//         T dir;
//     }
//     this(T v, T vmin = 0, T vmax = 1)
//     {
//         this.v = v;
//         this.vmin = vmin;
//         this.vmax = vmax;
//         this.tv = v;
//     }
//     @property void target (T tv)
//     {
//         this.tv = tv.clamp(vmin,vmax);
//         dir = tv < v ? -1 : 1;
//     }
//     @property void delta (T Δ)
//     {
//         this.Δv = max(Δ,0);
//     }
//     @property void Δ (T d)
//     {
//         this.Δv = max(d,0);
//     }
//     void hitTargetIn (T tv, Duration d)
//     {
//         this.tv = tv.clamp(vmin,vmax);
//         this.Δv = abs(tv-v) / (d/freq);
//     }
//     enum empty = false;
//     @property T front ()
//     {
//         return v;
//     }
//     void popFront ()
//     {
//         v += (dir*(min(abs(tv-v),Δv)));
//     }
//     T opIndex(size_t index)
//     {
//       return v + (dir*(min(abs(tv-v), Δv*index)));  
//     }

//     import core.time : Duration;
//     import std.math : abs, min, max;
//     import std.algorithm.comparison : clamp;
// }

//  struct CircularMap(T)
// {
//     this(ref SDLSurface inSurface, vec2!int size, vec2!int inSize, int innerRadius, int outerRadius)
//     {
//         this.inSurface = inSurface;
//         this.size = size;
//         this.inSize = inSize;
//         this.innerRadius = innerRadius;
//         this.outerRadius = outerRadius;

//         map = memory.allocator.makeArray!ubyte(size.x*size.y);
//         // encodes 4 regions per row indicating how many
//         // many pixels make up each regions
//         scanmap = memory.allocator.makeArray!int(4*size.y);
        
//         vec2!int center; center[] = size[]/2;
//         auto pitch = inSurface.pitch;
//         auto bpp = inSurface.format.BytesPerPixel;
//         T[] pixels = (cast(T *) inSurface.pixels)[0..inSize.x*inSize.y];

//         foreach (y; 0..size.y)
//         {
//             // the number of consecutive runs of hits or misses
//             auto nRuns = 0;
//             // count of consecutive written/non written pixels
//             // positive written negative not written
//             auto pixelsCount = 0;

//             foreach(x; 0..size.x)
//             {
//                 vec2!float offset = vec2!float(cast(float)(y-center.y),cast(float)(center.x-x));
//                 float Θ = atan2(offset.y,offset.x);

//                 vec2!float pos = vec2!float(inSize.x*(Θ+π)/(π*2.0),0.0);
//                 pos.y = (sin(Θ) == 0) ? 
//                     (offset.x-innerRadius)*inSize.y/outerRadius : 
//                     (offset.y/sin(Θ)-innerRadius)*inSize.y/outerRadius;

//                 size_t index = y*size.x + x;

//                 if (pos.x >= 0 && pos.x < inSize.w && 
//                     pos.y >= 0 && pos.y < inSize.h)
//                 {
//                     // position in is map area - write into map
//                     map[index] = pixels[cast(int)pos.y*pitch + cast(int)pos.x*bpp];

//                     //this is the start of a run of hits
//                     if (pixelsCount <= 0) 
//                     {
//                         // write number of empty pixels from last run to here
//                         scanmap[y*4+nRuns] = -pixelsCount;
//                         nRuns++;
//                         pixelsCount = 0;
//                     }
//                     //register a hit
//                     pixelsCount++;
//                 }
//                 else // its a miss 
//                 {
//                     map[index] = 0;

//                     // last position was a hit
//                     // this is the first in a run of misses 
//                     if (pixelsCount > 0)
//                     {
//                         scanmap[y*4+nRuns] = pixelsCount;
//                         nRuns++;
//                         pixelsCount = 0;
//                     }
//                     //register a miss
//                     pixelsCount--;
//                 }
//             }

//             // last x value was a hit
//             // record another run 
//             if (pixelsCount > 0) 
//             {
//                 scanmap[y*4+nRuns] = pixelsCount;
//                 nRuns++;
//             }   
//             // if there are less than 4 nruns 
//             // encode that into the scanmap
//             for(; nRuns < 4; nRuns++)
//             {
//                 scanmap[y*4 + nRuns] = -1;
//             }  
//         }
//     }
//     ~this()
//     {
//         memory.allocator.dispose(scanmap);
//         memory.allocator.dispose(map);
//     }
   
//     bool createMap(ref SDLSurface outSurface, vec2!int dest)
//     {
//         int bpp = outSurface.format.BytesPerPixel;
//         enforce (bpp == inSurface.format.BytesPerPixel,"VIDEO: error tmp buffer and video screen not same depth");

//         if ( dest.x < 0 || dest.x+size.x >= outSurface.w ||  
//              dest.y < 0 || dest.y+size.y >= outSurface.h)
//         {
//             return true;
//         }

//         if (outSurface.mustLock)
//             enforce( outSurface.lock() == 0, "VIDEO : failed to lock surface");

//         ubyte[] read = map[0..$];
//         ubyte[] read2;
//         ubyte[] write = cast(ubyte[]) outSurface.pixels[];
//         ubyte[] write2;
//         int[] readScanmap = scanmap[0..$];


//         foreach(y; 0..size.y)
//         {
//             read = read[size.x..$];
//             write = write[outPitch..$];
//             readScanmap = readScanmap[scanLeft..$];


//             while(offset != -1 && scanLeft)
//             {
//                 switch (bpp)
//                 {
//                     case 1:
//                     {
//                         foreach(i;0..offset)
//                         {

//                         }
//                     }
//                 }
//             }            
//         }

//         if (outSurface.mustLock) outSurface.unlock();
 
//         return false;
//     }

//     // ref CircularMap scan(int size)
//     // {

//     // } 

    


//     SDLSurface inSurface;
//     ubyte[] map;
//     int[] scanmap;
//     vec2!int size;
//     vec2!int inSize;
//     int innerRadius;
//     int outerRadius;

//     import sdl2.surface;
//     import std.math: atan2, PI, sin;
//     alias π = PI;
// }