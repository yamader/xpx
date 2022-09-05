module xpx.utils;
@safe:

import std;

auto avg(T)(T[] a) => a.reduce!`a+b` / real(a.length);
auto toa(T, U)(U[] a) => a[].map!(to!T).array;
