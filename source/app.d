import std.stdio;
import nogc.exception : enforce;

import memory, video, audio, input;
version(X11) import xlib;
import sdl2.core;


/// 
void go () @safe
{
	version(X11) { enforce (xlib.initThreads, "CORE: xlib needs to be multithreaded"); }
	else { assert (0,"CORE: currently xwindows only supported"); }

	enforce ( sdl2.core.init(SDLInit.VIDEO|SDLInit.JOYSTICK) == 0, "CORE: failed to start SDL");

	video.start();
	scope(exit) video.stop();
	
	audio.open();
	scope(exit) audio.close();

	audio.start();
	scope(exit) audio.stop();

	input.start();
}

void main()
{
	go();
	writeln("Edit source/app.d to start your project.");
}
