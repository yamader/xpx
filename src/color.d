module xpx.color;
@safe:

import std;
import xpx.utils;

struct Color {
  ubyte[3] _rgb;
  ubyte _mono;

  this(ubyte[] init) {
    _rgb = init;
    _mono = _rgb.avg.to!ubyte;
  }
  this(ubyte r, ubyte g, ubyte b) {
    _rgb = [r, g, b];
    _mono = _rgb.avg.to!ubyte;
  }
  this(ubyte mono) { _rgb[] = _mono = mono; }

  auto r() const => _rgb[0];
  auto g() const => _rgb[1];
  auto b() const => _rgb[2];

  auto mono() const => _mono;
}
