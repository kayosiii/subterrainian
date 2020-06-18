module video;
import vectortype;
import core.thread : Thread;
import core.sync.mutex : Mutex;
import core.time : msecs, Duration;

import std.conv : emplace;

import sdl2.core, sdl2.window, sdl2.renderer;
import memory;
import video.audioloop : AudioLoopDisplay;
import sdl2.c.types: SDL_Color;

void start() @trusted nothrow
{
    thread.start();
}

void stop() @nogc @trusted nothrow
{
    _running = false;
    while(thread.isRunning) Thread.sleep(msecs(10));
}

// int drawText (ref SDLSurface outSurface, ref SDLFont font, 
//               string str, vec2!int pos, SDL_Color c, 
//               vec2!byte justify, ref vec2!int s)
// {
    
//     SDL_Color black = {0,0,0,0};
//     SDLSurface text = font.renderTextShaded(str,c,black);
//     SDL_Rect dsrect = {pos.x,pos.y,text.w,text.h};
//     if (s.x != 0) s.x = pos.x;
//     if (s.y != 0) s.y = pos.y;
//     if (justify.x) dsrect.x -= (justify.x == 1 ? dsrect.w/2 : dsrect.w);
//     if (justify.y) dsrect.y -= (justify.y == 1 ? dsrect.h/2 : dsrect.h);
//     text.colorKey = SDL_SRCCOLORKEY|SDL_RLEACCEL;
//     text.Blit(outSurface,dsrect);
//     destroy(text);
// }

// pragma(inline, true)
// vec2!int Convert(vec2!float p) pure nothrow @safe @nogc 
// {
//     return  vec2!int(cast(int)(p.x*screen.w),cast(int)(p.y*screen.h));
// }

// vec2!int OConvert( vec2!int p)
// {
//     return Convert(vec2!float(cast(float)(p.x/screen.w),cast(float)(p.y/screen.h)));
// }






shared static this()
{
    lock = memory.allocator.make!Mutex();
    thread = memory.allocator.make!Thread(&run_thread,128*1024);
    //thread.priority = Thread.PRIORITY_MIN;
    thread.name = "Video";
}

shared static ~this()
{
    memory.allocator.dispose(thread);
    memory.allocator.dispose(lock);
}

Thread thread;
__gshared Mutex lock;
__gshared bool _running;
SDLRect!int screen = {100,100,1280,720};
immutable delay = msecs(40);
const static int num_loopcolors = 4;
SDL_Color[4][num_loopcolors] loopColors = [
    [{ 0x5F, 0x7C, 0x2B, 0 },{ 0xD3, 0xFF, 0x82, 0 },{ 0xFF, 0xFF, 0xFF, 0 },{ 0xDE, 0xE2, 0xD5, 0 } ],
    [{ 0x8E, 0x75, 0x62, 0 },{ 0xFF, 0x9C, 0x4C, 0 },{ 0xFF, 0xFF, 0xFF, 0 },{ 0xE0, 0xDA, 0xD5, 0 } ],
    [{ 0x62, 0x8C, 0x85, 0 },{ 0x43, 0xF2, 0xD5, 0 },{ 0xFF, 0xFF, 0xFF, 0 },{ 0xA9, 0xC6, 0xC1, 0 } ],
    [{ 0x69, 0x4B, 0x89, 0 },{ 0xA8, 0x56, 0xFF, 0 },{ 0xFF, 0xFF, 0xFF, 0 },{ 0xDF, 0xCB, 0xF4, 0 } ]];                                 
                                            


SDLWindow window = void;
SDLRenderer renderer = void;
AudioLoopDisplay loop = void;

void run_thread() @nogc @trusted
{
    video._running = true;

    synchronized (lock)
    {
        emplace(&window,"subterrainian",screen,SDL_WindowFlags.SHOWN);
        renderer = window.createRenderer(0,SDL_RendererFlags.ACCELERATED);
        emplace(&loop,renderer,SDL_Point(440,120),96);
    }
    // loop = AudioLoopDisplay(renderer,SDL_Point(240,120));
    int i = 0;
    while (_running)
    {
        synchronized (lock)
        {            
            renderer.color = SDL_Color(0,0,0,255);
            renderer.clear();
            renderer.color = SDL_Color(127,0,0,255);
            // renderer.drawVLine(SDL_Point(100,100),100);
             renderer.fillCircle(SDL_Point(100,100),100);
            // renderer.drawCircle(SDL_Point(100,100),100);
            // renderer.drawPie(SDL_Point(100,100), 100, 0, 64);
            renderer.fillPie(SDL_Point(120,120), 100, 0, i);
            loop.draw(1.0,loopColors[1],127);
            renderer.present();
            Thread.sleep(delay);
        }
        i++;
    }
}
