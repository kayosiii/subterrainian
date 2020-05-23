module video;
import vector;
import core.thread : Thread;
import core.sync.mutex : Mutex;
import core.time : msecs, Duration;

import std.conv : emplace;

import sdl2.core, sdl2.window, sdl2.renderer;
import memory;

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
SDLRect!int screen = {100,100,100,100};
immutable delay = msecs(40);

SDLWindow window = void;
SDLRenderer renderer = void;

void run_thread() @nogc @trusted
{
    video._running = true;

    synchronized (lock)
    {
        emplace(&window,"subterrainian",screen,SDL_WindowFlags.SHOWN);
        renderer = window.createRenderer(0,SDL_RendererFlags.ACCELERATED);
    }

    while (_running)
    {
        synchronized (lock)
        {
            renderer.clear();
            renderer.present();
            renderer.color = SDL_Color(0,0,0,255);
            Thread.sleep(delay);
        }
    }
}
