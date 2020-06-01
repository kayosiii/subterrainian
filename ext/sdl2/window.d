module sdl2.window;

import core.stdc.string : strlen;
import vectortype;

public import sdl2.c.types : SDL_WindowFlags, SDL_RendererFlags, SDL_FullscreenMode;
import sdl2.renderer, sdl2.surface;


struct SDLWindow
{
public import sdl2.c.types : SDL_Window, SDLRect,SDL_bool;
import sdl2.c.sdl : SDL_GetWindowDisplayIndex, SDL_SetWindowDisplayMode, SDL_GetWindowDisplayMode, SDL_GetWindowPixelFormat,
                    SDL_CreateWindow, SDL_CreateWindowFrom, SDL_GetWindowID, SDL_GetWindowFromID,
                    SDL_GetWindowFlags, SDL_SetWindowTitle, SDL_GetWindowTitle, SDL_SetWindowIcon,
                    SDL_SetWindowData, SDL_GetWindowData, SDL_SetWindowPosition, SDL_GetWindowPosition,
                    SDL_SetWindowSize, SDL_GetWindowSize, SDL_GetWindowBordersSize, SDL_SetWindowMinimumSize,
                    SDL_GetWindowMinimumSize, SDL_SetWindowMaximumSize, SDL_GetWindowMaximumSize, 
                    SDL_SetWindowBordered, SDL_SetWindowResizable, SDL_ShowWindow, SDL_HideWindow, SDL_RaiseWindow,
                    SDL_MaximizeWindow, SDL_MinimizeWindow, SDL_RestoreWindow, SDL_SetWindowFullscreen, 
                    SDL_GetWindowSurface, SDL_UpdateWindowSurface, SDL_UpdateWindowSurfaceRects,
                    SDL_SetWindowGrab, SDL_GetGrabbedWindow, SDL_SetWindowBrightness, SDL_GetWindowBrightness,
                    SDL_SetWindowOpacity, SDL_GetWindowOpacity, SDL_SetWindowModalFor, SDL_SetWindowInputFocus,
                    SDL_SetWindowGammaRamp, SDL_GetWindowGammaRamp, SDL_SetWindowHitTest, SDL_DestroyWindow;

    this (string name, SDLRect!int dims, uint flags) @trusted @nogc nothrow
    {
        ptr = SDL_CreateWindow(name.ptr, dims.x, dims.y, dims.w, dims.h, flags);
    }
    this (uint id)
    {
        ptr = SDL_GetWindowFromID(id);
    }
    ~this () @trusted @nogc nothrow
    {
        SDL_DestroyWindow(ptr);
    }
    SDLRenderer createRenderer(int index, uint flags) @trusted @nogc nothrow 
    {
        return SDLRenderer(ptr,index,flags);
    }
    @property SDLRenderer renderer() @trusted @nogc nothrow
    {
        return SDLRenderer(ptr);
    }
    @property int displayIndex () @trusted @nogc nothrow
    {
        return SDL_GetWindowDisplayIndex(ptr);
    }
    // @property void displayMode (int i) @trusted @nogc nothrow
    // {
    //     SDL_SetWindowDisplayMode(ptr,i);
    // }
    // @property int displayMode () @trusted @nogc nothrow
    // {
    //     return SDL_GetWindowDisplayMode(ptr);
    // }
    @property int pixelFormat () @trusted @nogc nothrow
    {
        return SDL_GetWindowPixelFormat (ptr);
    }
    @property uint id () @trusted @nogc nothrow
    {
        return SDL_GetWindowID(ptr);
    }
    @property uint flags () @trusted @nogc nothrow
    {
        return SDL_GetWindowFlags(ptr);
    }
    @property void title (string s) @trusted @nogc nothrow
    {
        SDL_SetWindowTitle(ptr,s.ptr);
    }
    @property string title () @trusted @nogc nothrow
    {
        auto tmp = SDL_GetWindowTitle(ptr);
        return cast(string) tmp[0..strlen(tmp)];
    }
    @property void icon(ref SDLSurface s) @trusted @nogc nothrow
    {
        SDL_SetWindowIcon(ptr,s.ptr);
    }
    void * setData(string name, void * data) @trusted @nogc nothrow
    {
        return SDL_SetWindowData(ptr,name.ptr,data);
    }
    void * getData(string name) @trusted @nogc nothrow
    {
        return SDL_GetWindowData(ptr,name.ptr);
    }
    @property void position(vec2!int p) @trusted @nogc nothrow
    {
        SDL_SetWindowPosition(ptr,p.x,p.y);
    }
    @property vec2!int position() @trusted @nogc nothrow
    {
        vec2!int r;
        SDL_GetWindowPosition(ptr, &r.x, &r.y);
        return r;
    }
    @property void size (vec2!int s) @trusted @nogc nothrow
    {
        SDL_SetWindowSize(ptr,s.x,s.y);
    }
    @property vec2!int size () @trusted @nogc nothrow
    {
        vec2!int r;
        SDL_GetWindowSize(ptr,&r.x,&r.y);
        return r;
    }
    @property vec4!int borderSize ()  @trusted @nogc nothrow
    {
        vec4!int r;
        SDL_GetWindowBordersSize(ptr,&r.x,&r.y,&r.z,&r.w);
        return r;
    }
    @property void minimumSize (vec2!int min) @trusted @nogc nothrow
    {
        SDL_SetWindowMinimumSize(ptr,min.x,min.y);
    }
    @property vec2!int minimumSize () @trusted @nogc nothrow
    {
        vec2!int r;
        SDL_GetWindowMinimumSize(ptr,&r.x,&r.y);
        return r;
    }
    @property void maximumSize (vec2!int max) @trusted @nogc nothrow
    {
        SDL_SetWindowMaximumSize (ptr,max.x,max.y);
    }
    @property vec2!int maximumSize () @trusted @nogc nothrow
    {
        vec2!int r;
        SDL_GetWindowMaximumSize(ptr,&r.x,&r.y);
        return r;
    }
    @property void bordered (bool b) @trusted @nogc nothrow
    {
        SDL_SetWindowBordered(ptr,cast(SDL_bool)b);
    }
    @property void resizeable (bool b) @trusted @nogc nothrow
    {
        SDL_SetWindowResizable(ptr,cast(SDL_bool)b);
    }

    void show () @trusted @nogc nothrow
    {
        SDL_ShowWindow(ptr);
    }
    void hide () @trusted @nogc nothrow
    {
        SDL_HideWindow(ptr);
    }
    void raise () @trusted @nogc nothrow
    {
        SDL_RaiseWindow(ptr);
    }
    void maximize () @trusted @nogc nothrow
    {
        SDL_MaximizeWindow(ptr);
    }
    void minimize () @trusted @nogc nothrow
    {
        SDL_MinimizeWindow(ptr);
    }
    void restore () @trusted @nogc nothrow
    {
        SDL_RestoreWindow(ptr);
    }
    @property void fullscreen (SDL_FullscreenMode mode)
    {
        SDL_SetWindowFullscreen(ptr,mode);
    }
    int updateSurface ()
    {
        return SDL_UpdateWindowSurface(ptr);
    }
    int updateSurfaceRects (const(SDLRect!int) [] rects)
    {
        return SDL_UpdateWindowSurfaceRects(ptr,rects.ptr,cast(int) rects.length);
    }
    @property void grabbed (bool b)
    {
        SDL_SetWindowGrab(ptr,cast(SDL_bool)b);
    }
    // @property bool grabbed ()
    // {
    //     return cast(bool) SDL_GetGrabbedWindow(ptr);
    // }
    @property void brightness(float br)
    {
        SDL_SetWindowBrightness(ptr,br);
    }
    @property float brightness ()
    {
        return SDL_GetWindowBrightness(ptr);
    }
    @property void modalFor(ref SDLWindow w)
    {
        SDL_SetWindowModalFor(ptr,w.ptr);
    }
    int setInputFocus()
    {
        return SDL_SetWindowInputFocus(ptr);
    }
    // @property void gammaRamp()
    // @property gammaRamp()
    // @property hittest
    SDL_Window * ptr;
}