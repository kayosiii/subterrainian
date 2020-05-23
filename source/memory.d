module memory;

import std.experimental.allocator : RCIAllocator, allocatorObject;
public import std.experimental.allocator : make, dispose, makeArray, makeMultidimensionalArray, disposeMultidimensionalArray;
import std.experimental.allocator.mallocator;

shared static this()
{
  allocator = allocatorObject(Mallocator.instance);
  stringAllocator = allocatorObject(Mallocator.instance);
}


/// stopgap measure so far 
/// this one is the general purpose allocator.
RCIAllocator allocator;
/// this one can eventually be optimised specifically 
/// for storing strings
RCIAllocator stringAllocator;