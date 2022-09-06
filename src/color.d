module xpx.color;
@safe:

import std;
import xpx.utils;

struct Color {
  ubyte[3] _rgb;
  ubyte _mono;

  this(ubyte[] init) { set(init); }
  this(ubyte r, ubyte g, ubyte b) { set(r, g, b); }
  this(ubyte mono) { set(mono); }

  auto set(ubyte[] init) {
    _rgb = init;
    _mono = _rgb.avg.to!ubyte;
    return _rgb;
  }
  auto set(ubyte r, ubyte g, ubyte b) {
    _rgb = [r, g, b];
    _mono = _rgb.avg.to!ubyte;
    return _rgb;
  }
  auto set(ubyte mono) {
    _rgb[] = _mono = mono;
    return _mono;
  }

  auto r() const => _rgb[0];
  auto g() const => _rgb[1];
  auto b() const => _rgb[2];
  auto mono() const => _mono;

  auto rgbs() const => _rgb.toa!string;
  auto monos() const => _mono.to!string;
}
