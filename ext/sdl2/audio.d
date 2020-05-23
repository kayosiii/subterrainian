module sdl2.audio;
// import core.stdc.string : strlen;

// public import sdl2.c.types : SDL_AudioSpec, SDL_RWops, SDL_AudioCVT,
//                              SDL_AudioFormat, _SDL_AudioStream;

// @property int numDrivers() @nogc nothrow @trusted
// {
//     import sdl2.c.sdl : SDL_GetNumAudioDrivers;
//     return SDL_GetNumAudioDrivers();
// }

// string getDriver(int i) @nogc nothrow @trusted
// {
//     import sdl2.c.sdl : SDL_GetAudioDriver;
//     auto tmp = SDL_GetAudioDriver(i);
//     return cast(string) tmp[0..strlen(tmp)];
// }

// void init (string driverName) @nogc nothrow @trusted
// {
//     import sdl2.c.sdl : SDL_AudioInit;
//     return SDL_AudioInit(driverName.ptr);
// } 

// void quit() @nogc nothrow @trusted
// {
//     import sdl2.c.sdl : SDL_AudioQuit;
//     return  SDL_AudioQuit();
// }

// @property string currentDriver () @nogc nothrow @trusted
// {
//     import sdl2.c.sdl : SDL_GetCurrentAudioDriver;
//     auto tmp = SDL_GetCurrentAudioDriver();
//     return cast(string) tmp[0..strlen(tmp)];
// }

// int open (ref SDL_AudioSpec desired, ref SDL_AudioSpec obtained) @nogc nothrow @trusted
// {
//     import sdl2.c.sdl : SDL_OpenAudio;
//     return SDL_OpenAudio(&desired,&obtained);
// }

// int getNumDevices (int i) @nogc nothrow @trusted
// {
//     import sdl2.c.sdl : SDL_GetNumAudioDevices;
//     return SDL_GetNumAudioDevices(i);
// } 

// string getDeviceName (int i, bool isCapture) @nogc nothrow @trusted
// {
//     import sdl2.c.sdl : SDL_GetAudioDeviceName;
//     auto tmp = SDL_GetAudioDeviceName(i,isCapture);
//     return cast(string) tmp[0..strlen(tmp)];
// } 

// SDL_AudioDeviceID openDevice (string device, bool isCapture, const ref SDL_AudioSpec desired, ref SDL_AudioSpec obtained, int allowChanges) @nogc nothrow @trusted
// {
//     import sdl2.c.sdl : SDL_OpenAudioDevice;
//     return SDL_OpenAudioDevice(device.ptr, isCapture, &desired, &obtained, allowChanges);
// }

// @property SDL_AudioStatus status() @nogc nothrow @trusted
// {
//    import sdl2.c.sdl :  SDL_GetAudioStatus;
//    return SDL_GetAudioStatus();
// }


// void pause(bool on) @nogc nothrow @trusted
// {
//     import sdl2.c.sdl : SDL_PauseAudio;
//     SDL_PauseAudio(on);
// }

// ref SDL_AudioSpec loadWAV_RW(ref SDL_RWops src, bool freeSrc, ref SDL_AudioSpec spec, ref ubyte buffer) @nogc nothrow @trusted
// {
//     import sdl2.c.sdl : SDL_LoadWAV_RW;
//     auto r = SDL_LoadWAV_RW(&src, freeSrc, &spec, &buffer.ptr, &buffer.length);
//     return *r;
// }

// void freeWAV(ref ubyte buffer) @nogc nothrow @trusted
// {
//     import sdl2.c.sdl : SDL_FreeWAV;
//     SDL_FreeWAV(&buffer);
// }

// int buildCVT(ref SDL_AudioCVT cvt, 
//              SDL_AudioFormat srcFmt, ubyte srcChannels, int srcRate,
//              SDL_AudioFormat dstFmt, ubyte dstChannels, int dstRate) @nogc nothrow @trusted
// {
//     import sdl2.c.sdl : SDL_BuildAudioCVT;
//     return SDL_BuildAudioCVT(&cvt, srcFmt, srcChannels, srcRate, dstFmt, dstChannels, dstRate);
// }

// int convert(ref SDL_AudioCVT cvt) @nogc nothrow @trusted
// {
//     import sdl2.c.sdl : SDL_ConvertAudio;
//     return SDL_ConvertAudio(&cvt);
// }


// struct SDLAudioStream 
// {
//     this(const(ushort) srcFmt, const(ubyte) srcChannels, const(int) srcRate,
//          const(ushort) dstFmt, const(ubyte) dstChannels, const(int) dstRate) @nogc nothrow @trusted
//     {
//         import sdl2.c.sdl : SDL_NewAudioStream;
//         ptr = SDL_NewAudioStream(srcFmt,srcChannels,srcRate,dstFmt,dstChannels,dstRate);
//     }
//     ~this() @nogc nothrow @trusted
//     {
//         import sdl2.c.sdl : SDL_FreeAudioStream;
//         SDL_FreeAudioStream(ptr);
//     }
//     int put(const(void)[]buf) @nogc nothrow @trusted
//     {
//         import sdl2.c.sdl : SDL_AudioStreamPut;
//         return SDL_AudioStreamPut(ptr, buf.ptr, buf.length);
//     }
//     int get(void[] buf) @nogc nothrow @trusted
//     {
//         import sdl2.c.sdl : SDL_AudioStreamGet;
//         return SDL_AudioStreamGet(ptr, buf.ptr, buf.length);
//     }
//     @property bool available() @nogc nothrow @trusted
//     {
//         import sdl2.c.sdl : SDL_AudioStreamAvailable;
//         return cast(bool) SDL_AudioStreamAvailable(ptr);
//     }
//     int flush() @nogc nothrow @trusted
//     {
//         import sdl2.c.sdl : SDL_AudioStreamFlush;
//         return SDL_AudioStreamFlush(ptr);
//     }
//     void clear() @nogc nothrow @trusted
//     {
//         import sdl2.c.sdl : SDL_AudioStreamClear;
//         return SDL_AudioStreamClear(ptr);
//     } 

//     _SDL_Audiostream * ptr;
// }

// struct SDL_AudioDevice
// {
//     this(string device, bool isCapture, const ref SDL_AudioSpec desired, ref SDL_AudioSpec obtained, int allowChanges) @nogc nothrow @trusted
//     {
//         import sdl2.c.sdl : SDL_OpenAudioDevice;
//         dev = SDL_OpenAudioDevice(device.ptr, isCapture, &desired, &obtained, allowChanges);
//     }
//     this(uint i) { dev = i;}

//     @property SDL_AudioStatus status() @nogc nothrow @trusted
//     {
//         import sdl2.c.sdl :  SDL_GetAudioDeviceStatus;
//         return SDL_GetAudioDeviceStatus(i);
//     }

//     void pause(bool on) @nogc nothrow @trusted
//     {
//         import sdl2.c.sdl : SDL_PauseAudioDevice;
//         SDL_PauseAudioDevice(dev,on);
//     }

//     int queue (const(void)[] data) @nogc nothrow @trusted
//     {
//         import sdl2.c.sdl : SDL_QueueAudio;
//         return SDL_QueueAudio (dev,data.ptr, data.length);
//     }

//     int dequeue (void[] data) @nogc nothrow @trusted
//     {
//         import sdl2.c.sdl : SDL_DequeueAudio;
//         return SDL_DequeueAudio (dev, data.ptr, data.length);
//     }

//     void clearQueue (SDL_AudioDeviceID dev) @nogc nothrow @trusted
//     {
//         import sdl2.c.sdl : SDL_ClearQueuedAudio;
//         SDL_ClearQueuedAudio(dev);
//     }

//     void lock() @nogc nothrow @trusted
//     {
//         import sdl2.c.sdl : SDL_LockAudioDevice;
//         SDL_LockAudioDevice(dev);
//     }

//     void unlock() @nogc nothrow @trusted
//     {
//         import sdl2.c.sdl : SDL_UnlockAudioDevice;
//         SDL_UnlockAudioDevice(dev);
//     }

//     void close() @nogc nothrow @trusted
//     {
//         import sdl2.c.sdl : SDL_CloseAudioDevice;
//         SDL_CloseAudioDevice(dev);
//     }

//     SDL_AudioDeviceID dev;
// } 

// void mix (ref ubyte[] dst, const(ubyte[]) src, int vol) @nogc nothrow @trusted
// {
//    import sdl2.c.sdl : SDL_MixAudio;
//    SDL_MixAudio(dst.ptr, src.ptr, src.length, vol); 
// }

// void mix (ref ubyte[] dst, const(ubyte[]) src, SDL_AudioFormat fmt, int volume)
// {
//     import sdl2.c.sdl : SDL_MixAudioFormat;
//     SDL_MixAudioFormat (dst.ptr,src.ptr,fmt,volume);
// }

// void lock() @nogc nothrow @trusted
// {
//     import sdl2.c.sdl : SDL_LockAudio;
//     SDL_LockAudio();
// }

// void unlock() @nogc nothrow @trusted
// {
//     import sdl2.c.sdl : SDL_UnlockAudio;
//     SDL_UnlockAudio();
// }

// void close() @nogc nothrow @trusted
// {
//     import sdl2.c.sdl : SDL_CloseAudio;
//     SDL_CloseAudio();
// }



