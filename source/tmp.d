module tmp;

import nogc.exception : enforce;
import memory;
import vectortype;

import std.math : pow;
enum semitoneRatio = pow(2.0,1.0/12.0);
enum c5 = 220.0 * pow(semitoneRatio,3.0);
enum c0 = c5 * pow (0.5, 5.0);

T MIDINoteToFrequency(T)(int note)
{
    return c0 * pow(semitoneRatio, note); 
}
int FrequencyToMidiNote(T)(T frequency)
{
    return cast(int) ( log(frequency/c0) / log(semitoneRatio) + 0.5);
    import std.math : log;
}
enum Err
{
    none = 0,
    occured = 1
}

struct Smoother(T)
{
    private 
    { 
        T v; 
        T _target;
        T Δv;
        T vmax;
        T vmin;
        T freq;
    }
    this(T v, Duration time, double sampleRate, T vmin = 0, T vmax = 1)
    {
        this.v = v;
        this.vmin = vmin;
        this.vmax = vmax;
        this._target = v;
        this.Δv = time.total!"seconds" / sampleRate;
    }
    @property T value ()
    {
        return v;
    }
    @property void target (T tv)
    {
        atomicStore(_target,tv.clamp(vmin,vmax));
    }
    @property void delta (T Δ)
    {
        this.Δv = max(Δ,0);
    }
    @property void Δ (T d)
    {
        this.Δv = max(d,0);
    }
    enum empty = false;
    @property T front ()
    {
        return v;
    }
    void popFront ()
    {
        auto tv = atomicLoad!()(_target);
        if (tv == v) return;
        auto dir = tv > v ? 1.0 : -1.0;
        v += (dir*(min(abs(tv-v),Δv)));
    }
    T opIndex(size_t index)
    {
        auto tv = atomicLoad!()(_target);
        if (tv == v) return v;
        auto dir = tv > v ? 1.0 : -1.0;
        return v + (dir*(min(abs(tv-v), Δv*index)));  
    }

    import core.atomic : atomicStore, atomicLoad, MemoryOrder;
    import core.time : Duration, seconds;
    import std.math : abs;
    import std.algorithm.comparison : max,min,clamp;

}

struct sinGenerator
{
    this(float samplerate,float freq)
    {
        this.sampleRate = samplerate;
        // frequency = Smoother!float(freq,0.0,float.max);
    }
    enum empty = false;
    @property float front ()
    {
        return sin(2*π*frequency.value*pos/sampleRate);
    }
    void popFront()
    {
        pos += 1.0;
    }
    float pos;
    Smoother!float  frequency = void;
    float sampleRate;
    size_t chunckSize;
    import std.math : PI, sin;
    alias π = PI;
}

enum WaveTableType
{
    ARBITRARY = -1,
    SINE = 0,
    SQUARE = 1,
    SAW = 2,
    TRIANGLE = 3
}

struct WaveTable(T)
{
    this (ref T[] table, size_t sampleRate)
    {
        this.table = table;
        this.sampleRate = sampleRate;

    }
    this (WaveTableType type, size_t length)
    in { assert (type >= 0 && type <= WaveTableType.TRIANGLE); }
    body
    {
        table = memory.allocator.makeArray!T(length);
        float pos = 0.0; 
        float ln = cast(float) length;
        final switch(type) with (WaveTableType)
        {
            case ARBITRARY: break;
            case SINE:
                foreach (ref sample; table)
                {
                    sample = sin(2*π*pos/ln);
                    pos += 1.0;
                }
                break;
            case SQUARE:
                table[0..table.length/2] = 1.0;
                table[table.length/2..$] = -1.0;
                break;
            case SAW:
                foreach (ref sample; table)
                {
                    sample = 1.0 - (2.0 * pos / ln);
                    pos += 1.0;
                }
                break;
            case TRIANGLE:
                float halfln = ln / 2.0;
                foreach (ref sample; table[0..table.length/2])
                {
                    sample = 2*pos/halfln-1.0;
                    pos += 1.0;
                }
                foreach (ref sample; table[table.length/2..$])
                {
                    sample = 1.0 - (2*(pos - halfln)/halfln);
                    pos += 1.0;
                }
                break;
        }
    }

    T[] table;
    size_t sampleRate;
    WaveTableType type;
    import std.math : PI, sin;
    alias PI = π;
}

struct Panner(T)
{
    enum halfπ = PI/2.0;
    enum halfRoot2 = SQRT2*0.5;
    Smoother!T angle;
    enum empty = false;
    @property T front()
    {

    }
    T panStereoLeft(T input)
    {
        return halfRoot2 * (cos(angle.value) - sin(angle.value));
    }
    T panStereoRight()
    {
        return halfRoot2 * (cos(angle.value) + sin(angle.value));
    }
    import std.math : PI,SQRT2,sin,cos;
}

// void snippit (SDL_Renderer renderer)
// {
//     vec2!int sz = vec2!int(320,320);
//     SDLSurface loopAnnulus = SDLSurface(0,sz, 32,SDL_PIXELFORMAT.ARGB8888);
//     SDLTexture loopTex = renderer.makeTexture(SDL_PIXELFORMAT.ARGB8888,SDL_TEXTUREACCESS.STREAMING,sz);
//     loopTex.update(null,surface.pixels,surface.pitch);
//     renderer.clear();
//     renderer.copy(loopTex);
//     renderer.present();
// }

import std.typecons : tuple;
pragma(inline,true) T[] lerp(T) (T[] t1, T[] t2, T v)
if (__traits(isFloating,T))
{
    return t1[] * v + t2[] * (1.0-v);
}
pragma(inline,true) inout(T) lerpStaticArray(T,M,S)(inout(T) t1, inout(T) t2, S v)
    if (__traits(isStaticArray,M))
{
    T r;
    S inverse = 1.0 - v;
    static if (__traits(isFloating,M))
    {
        r[] = t1[]*v + t2[]*inverse;
    }
    else 
    {
        foreach(i; 0..M.length)
        {
            r[i] = cast(typeof(r[i])) (cast(S)t1[i]*v + cast(S)t2[i]*inverse);
        }
    }
    return r;
}

inout(T) lerp(T,S)(inout(T) t1, inout(T) t2, S v)
    if (__traits(isFloating,S))
{
    import std.traits : isNumeric;
    static if (isNumeric!T)
    {
        return t1*v + t2*(1.0-v);
    }
    else static if (__traits(isStaticArray,T) && isNumeric!(typeof(t1[0]))) 
    {
        return lerpStaticArray!(T,T,S)(t1,t2,v);
    }
    static foreach(M; __traits(getAliasThis,T))
    {
        static if (__traits(isStaticArray,__traits(getMember,T,M))&&isNumeric!(typeof(t1[0])))
        {
            return lerpStaticArray!(T,typeof(__traits(getMember,T,M)),S)(t1,t2,v);
        }
    }
}








// private void _ellipseAA(SDL_Point p, Pair radius)
// in { assert(radius.x >= 0 && radius.y >= 0); }
// body
// {
//     if (radius.x == 0)
//     {
//         if (radius.y == 0) return drawPoint(p);
//         else return drawLine( {p.x; p.y-radius.y;}, {p.x; p.y+radius.y;} );
//     }
//     else if (radius.y == 0)
//     {
//         return drawLine( {p.x-radius.x; p.y;}, {p.x+radius.x; p.y;} );
//     }

//     auto r2 = radius * radius;
//     auto Δs = r2.x * 2;
//     auto Δt = r2.y * 2;
//     auto c2 = p * 2;
//     auto sab = sqrt(cast(double)(r2.x+r2.y));
//     auto od = lrint(sab*0.01) + 1;
//     auto dxt = lrint(cast(double)r2.x / sab) + od;
//     auto s = -2 * r2.x * radius.y;
//     auto p0 = SDL_Point(p.x,p.y-radius.y);

//     auto c = this.color;
//     this.blendMode = (c.a == 255) ? SDL_BLENDMODE.NONE : SDL_BLENDMODE.BLEND ;

//     drawPoint(p0);
//     drawPoint({c2.x-p0.x; p0.y;});
//     drawPoint({p0.x; c2.y-p0.y;});
//     drawPoint({c2.x-p0.x; c2.y-p0.y;});

//     foreach(i; 0..dxt)
//     {
//         p0.x--;
//         d += t - r2.y;

//         if (d >= 0) s.y = p0.y - 1;
//         else if ((d - s - r2.x) > 0)
//         {
//             if ((2*d-s-r2.x) >= 0) s.y = p.y + 1;
//             else 
//             {
//                 s.y = p.y;
//                 p.y++;
//                 d -= s + r2.x;
//                 s += Δs;
//             }
//         }
//         else
//         {
//             p.y++;
//             s.y = p.y + 1;
//             d -= s + r2.x;
//             s += Δs;
//         }
//         t -= Δt;

//         auto cp = (s == 0) ? 1.0 : min(cast(float) abs(d) / cast(float) abs(s), 1.0f);
//         auto weightedColor = c.withAlphaWeight(cast(ubyte)(cp*255));
//         auto iWeightedColor = c.withAlphaWeight(cast(ubyte)(255-cp*255));


//     }
// }
// int aaellipseRGBA(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rx, Sint16 ry, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
// {
// 	int result;
// 	int i;
// 	int a2, b2, ds, dt, dxt, t, s, d;
// 	Sint16 xp, yp, xs, ys, dyt, od, xx, yy, xc2, yc2;
// 	float cp;
// 	double sab;
// 	Uint8 weight, iweight;


// 	for (i = 1; i <= dxt; i++) {
// 		xp--;
// 		d += t - b2;

// 		if (d >= 0)
// 			ys = yp - 1;
// 		else if ((d - s - a2) > 0) {
// 			if ((2 * d - s - a2) >= 0)
// 				ys = yp + 1;
// 			else {
// 				ys = yp;
// 				yp++;
// 				d -= s + a2;
// 				s += ds;
// 			}
// 		} else {
// 			yp++;
// 			ys = yp + 1;
// 			d -= s + a2;
// 			s += ds;
// 		}

// 		t -= dt;

// 		/* Calculate alpha */
// 		if (s != 0) {
// 			cp = (float) abs(d) / (float) abs(s);
// 			if (cp > 1.0) {
// 				cp = 1.0;
// 			}
// 		} else {
// 			cp = 1.0;
// 		}

// 		/* Calculate weights */
// 		weight = (Uint8) (cp * 255);
// 		iweight = 255 - weight;

// 		/* Upper half */
// 		xx = xc2 - xp;
// 		result |= pixelRGBAWeight(renderer, xp, yp, r, g, b, a, iweight);
// 		result |= pixelRGBAWeight(renderer, xx, yp, r, g, b, a, iweight);

// 		result |= pixelRGBAWeight(renderer, xp, ys, r, g, b, a, weight);
// 		result |= pixelRGBAWeight(renderer, xx, ys, r, g, b, a, weight);

// 		/* Lower half */
// 		yy = yc2 - yp;
// 		result |= pixelRGBAWeight(renderer, xp, yy, r, g, b, a, iweight);
// 		result |= pixelRGBAWeight(renderer, xx, yy, r, g, b, a, iweight);

// 		yy = yc2 - ys;
// 		result |= pixelRGBAWeight(renderer, xp, yy, r, g, b, a, weight);
// 		result |= pixelRGBAWeight(renderer, xx, yy, r, g, b, a, weight);
// 	}

// 	/* Replaces original approximation code dyt = abs(yp - yc); */
// 	dyt = (Sint16)lrint((double)b2 / sab ) + od;    

// 	for (i = 1; i <= dyt; i++) {
// 		yp++;
// 		d -= s + a2;

// 		if (d <= 0)
// 			xs = xp + 1;
// 		else if ((d + t - b2) < 0) {
// 			if ((2 * d + t - b2) <= 0)
// 				xs = xp - 1;
// 			else {
// 				xs = xp;
// 				xp--;
// 				d += t - b2;
// 				t -= dt;
// 			}
// 		} else {
// 			xp--;
// 			xs = xp - 1;
// 			d += t - b2;
// 			t -= dt;
// 		}

// 		s += ds;

// 		/* Calculate alpha */
// 		if (t != 0) {
// 			cp = (float) abs(d) / (float) abs(t);
// 			if (cp > 1.0) {
// 				cp = 1.0;
// 			}
// 		} else {
// 			cp = 1.0;
// 		}

// 		/* Calculate weight */
// 		weight = (Uint8) (cp * 255);
// 		iweight = 255 - weight;

// 		/* Left half */
// 		xx = xc2 - xp;
// 		yy = yc2 - yp;
// 		result |= pixelRGBAWeight(renderer, xp, yp, r, g, b, a, iweight);
// 		result |= pixelRGBAWeight(renderer, xx, yp, r, g, b, a, iweight);

// 		result |= pixelRGBAWeight(renderer, xp, yy, r, g, b, a, iweight);
// 		result |= pixelRGBAWeight(renderer, xx, yy, r, g, b, a, iweight);

// 		/* Right half */
// 		xx = xc2 - xs;
// 		result |= pixelRGBAWeight(renderer, xs, yp, r, g, b, a, weight);
// 		result |= pixelRGBAWeight(renderer, xx, yp, r, g, b, a, weight);

// 		result |= pixelRGBAWeight(renderer, xs, yy, r, g, b, a, weight);
// 		result |= pixelRGBAWeight(renderer, xx, yy, r, g, b, a, weight);		
// 	}

// 	return (result);
// }


