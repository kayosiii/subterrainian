import std.stdio;
import nogc.exception : enforce;

import memory, video, audio, input;
import core.time : seconds, Duration;

import core.thread : Thread;
version(X11) import xlib;
import sdl2.core;


/// 
void go () 
{
	xlib.initThreads();

	// version(X11) { enforce (xlib.initThreads, "CORE: xlib needs to be multithreaded"); }
	// else { assert (0,"CORE: currently xwindows only supported"); }

	// enforce ( sdl2.core.init(SDLInit.VIDEO|SDLInit.JOYSTICK) == 0, "CORE: failed to start SDL");

	sdl2.core.init(SDLInit.VIDEO|SDLInit.JOYSTICK);
	
	video.start();
	scope(exit) video.stop();
	
	audio.open();
	scope(exit) audio.close();

	audio.start();
	scope(exit) audio.stop();
	Thread.sleep(seconds(1));
	input.start();
}

void main()
{
	go();
	writeln("Edit source/app.d to start your project.");
}
