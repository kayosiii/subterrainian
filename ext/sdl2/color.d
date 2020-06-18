module sdl2.color;

public import sdl2.c.types : SDL_Color;
import sdl2.c.sdl : SDL_MapRGBA;

// uint MapRGBA (SDL_Color c, const(uint) fmt)
// {
//     return SDL_MapRGBA(fmt,c.r,c.g,c.b,c.a);
// }