module sdl2._assert;

import sdl2.c.types : SDL_AssertData, SDL_AssertState;
import sdl2.c.sdl : SDL_ReportAssertion, SDL_SetAssertionHandler,
                    SDL_GetDefaultAssertionHandler,SDL_GetAssertionHandler,
                    SDL_GetAssertionReport, SDL_ResetAssertionReport;

SDL_AssertState reportAssertion(ref SDL_AssertData data, string fn, string file, int line) @nogc nothrow @trusted
{
    return SDL_ReportAssertion(&data, fn.ptr,file.ptr,line);
}

alias setAssertionHandler = SDL_SetAssertionHandler;
alias getDefaultHandler = SDL_GetDefaultAssertionHandler;
// alias getHandler = SDL_GetHandler;
@property const(SDL_AssertData)* assertionReport () @nogc nothrow @trusted
{
    return SDL_GetAssertionReport();
}
alias resetAssertionReport = SDL_ResetAssertionReport;
