module input;

import sdl2.events;

void start () @nogc @safe nothrow
{
    _running = true;
    run_thread();
}

void stop () @nogc @safe nothrow
{

}
private:
void run_thread() @nogc @trusted nothrow
{
    SDLEvent sdlEvent;
    while (_running)
    {
        if (sdlEvent.wait())
        {
            switch (sdlEvent.type) with (SDL_EventType)
            {
                case QUIT: _running = false; break;
                case KEYDOWN: 
                    switch (sdlEvent.key.keysym.scancode) with (SDL_Scancode)
                    {
                        case RETURN:
                        case ESCAPE:
                            _running = false;
                            break;
                        default: break;
                    }
                    break;
                default: break;
            }
        }
    }
}

shared bool _running;