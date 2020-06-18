module sdl2.memory;

import std.experimental.allocator : RCIAllocator, allocatorObject;
public import std.experimental.allocator : make, dispose, makeArray, makeMultidimensionalArray, disposeMultidimensionalArray;
import std.experimental.allocator.mallocator;

alias sdlAllocator = Mallocator.instance;

