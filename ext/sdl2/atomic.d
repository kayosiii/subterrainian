module sdl2.atomic;

public import sdl2.c.types : SDL_Spinlock, SDL_atomic_t;

bool tryLock( ref SDL_Spinlock lock ) @nogc nothrow @trusted
{
    import sdl2.c.sdl: SDL_AtomicTryLock;
    return cast(bool) SDL_AtomicTryLock(&lock);
}

void lock (ref SDL_Spinlock lock ) @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_AtomicLock;
    SDL_AtomicLock(&lock);
}

void unlock (ref SDL_Spinlock lock) @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_AtomicUnlock;
    SDL_AtomicUnlock(&lock);
}

bool CAS(ref SDL_atomic_t a, int old_val, int new_val) @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_AtomicCAS;
    return cast(bool) SDL_AtomicCAS(&a,old_val,new_val);
}

int set(ref SDL_atomic_t a, int v) @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_AtomicSet;
    return SDL_AtomicSet(&a,v);
}

int get(ref SDL_atomic_t a) @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_AtomicGet;
    return SDL_AtomicGet(&a);
}

int add(ref SDL_atomic_t a, int i) @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_AtomicAdd;
    return SDL_AtomicAdd(&a,i);
} 

bool CASPtr (void ** a, void * old, void *_new) @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_AtomicCASPtr;
    return cast(bool) SDL_AtomicCASPtr(a,old,_new);
}

void * setPtr(void ** a, void * v) @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_AtomicSetPtr;
    return SDL_AtomicSetPtr(a,v);
}

void * getPtr(void **a) @nogc nothrow @trusted
{
    import sdl2.c.sdl : SDL_AtomicGetPtr;
    return SDL_AtomicGetPtr(a);
}