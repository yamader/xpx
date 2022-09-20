module xpx.color;
@safe:

import std;
import xpx.utils;

struct Color {
  ubyte[3] rgb;
  ubyte mono;
  ubyte alpha;

  this(ubyte[] rgb, ubyte g, ubyte a) {
    this.rgb = rgb;
    mono = g;
    alpha = a;
  }
  this(int[] rgb, ubyte a = 255) {
    this(rgb.toa!ubyte, rgb.avg.to!ubyte, a);
  }
  this(int rl, int gl, int bl, ubyte a = 255) {
    auto r = cast(ubyte)rl,
         g = cast(ubyte)gl,
         b = cast(ubyte)bl;
    this([r, g, b], a);
  }
  this(int gl, ubyte a = 255) {
    auto g = cast(ubyte)gl;
    this([g, g, g], g, a);
  }

  auto r() const => rgb[0];
  auto g() const => rgb[1];
  auto b() const => rgb[2];

  auto rgbs() const => rgb.toa!string;
  auto monos() const => mono.to!string;
}

auto blend(Color bg, Color fg) {
  if(fg.alpha == 255) return fg;
  if(fg.alpha == 0) return bg;
  auto fa = fg.alpha / real(255),
       ba = bg.alpha / real(255);
  // 暫定
  return fg;
}
