module sdl2.events;

public import sdl2.c.types : SDL_CommonEvent, SDL_DisplayEvent, SDL_WindowEvent, SDL_KeyboardEvent, 
                             SDL_TextEditingEvent, SDL_TextInputEvent, SDL_MouseMotionEvent,
                             SDL_MouseButtonEvent, SDL_MouseWheelEvent, SDL_JoyAxisEvent,
                             SDL_JoyBallEvent, SDL_JoyHatEvent, SDL_JoyButtonEvent, SDL_JoyDeviceEvent,
                             SDL_ControllerAxisEvent, SDL_ControllerButtonEvent, SDL_ControllerDeviceEvent,
                             SDL_AudioDeviceEvent, SDL_SensorEvent, SDL_QuitEvent, SDL_UserEvent,
                             SDL_SysWMEvent, SDL_TouchFingerEvent, SDL_MultiGestureEvent,
                             SDL_DollarGestureEvent, SDL_DropEvent, SDL_EventType, SDL_Event, SDL_Scancode;

void pump() @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_PumpEvents;
    SDL_PumpEvents();
}

// void peep() @nogc nothrow @trusted
// {
//     import sdl2.c.sdl : SDL_PeepEvents;
//     SDL_PeepEvents();
// }

bool hasEvent(uint ev) @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_HasEvent;
    return cast(bool) SDL_HasEvent(ev);
}

bool hasEvents(uint lo, uint hi) @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_HasEvents;
    return cast(bool) SDL_HasEvents(lo,hi);
}

void flushEvent(uint ev) @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_FlushEvent;
    SDL_FlushEvent(ev);
}
void flushEvents(uint lo, uint hi) @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_FlushEvents;
    SDL_FlushEvents(lo,hi);
}


struct SDLEvent
{
    
    import sdl2.c.sdl : SDL_PollEvent, SDL_WaitEvent, SDL_WaitEventTimeout,
                        SDL_PushEvent, SDL_SetEventFilter,
                        SDL_GetEventFilter;
    int poll() @nogc @trusted nothrow { return SDL_PollEvent(&ev); }
    int wait() @nogc @trusted nothrow { return SDL_WaitEvent(&ev); }
    int push() @nogc @trusted nothrow { return SDL_PushEvent(&ev); }
    @property void timeout (int timeout) @nogc @trusted nothrow { SDL_WaitEventTimeout(&ev,timeout); }
    SDL_Event ev;
    alias ev this;
}