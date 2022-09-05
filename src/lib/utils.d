module xpx.lib.utils;
@safe:

import std;

auto toa(T, U)(U a) => a[].map!(to!T).array;
