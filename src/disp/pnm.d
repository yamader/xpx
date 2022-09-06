module xpx.disp.pnm;
@safe:

import std;
import xpx.color;
import xpx.disp.base;

private class DispPNM: DispFile {
  Color[][] _buf;
  size_t _w, _h;

  this() { this(Disp.defWidth, Disp.defHeight); }
  this(size_t w, size_t h) {
    _buf = new Color[][](h, w);
    _w = w, _h = h;
  }

  size_t w() const => _w;
  size_t h() const => _h;
  auto ws() const => _w.to!string;
  auto hs() const => _h.to!string;
  Color get(size_t x, size_t y) const => _buf[y][x];
  Color set(T: Color)(size_t x, size_t y, auto ref T c) => _buf[y][x] = c;

  void write(string path) {
    auto fout = File(path, "w");
    fout.write(writes);
  }

  abstract string writes();
}

class DispPBM: DispPNM {
  this() {}
  this(size_t w, size_t h) { super(w, h); }

  override string writes() {
    string s = "P1\n"~ws~" "~hs~"\n";
    return s;
  }
}

class DispPGM: DispPNM {
  this() {}
  this(size_t w, size_t h) { super(w, h); }

  override string writes() {
    string s = "P2\n"~ws~" "~hs~"\n255\n";
    foreach_reverse(row; 0..h)
      s ~= _buf[row].map!`a.monos`.join(" ") ~ "\n";
    return s;
  }
}

class DispPPM: DispPNM {
  this() {}
  this(size_t w, size_t h) { super(w, h); }

  override string writes() {
    string s = "P3\n"~ws~" "~hs~"\n255\n";
    foreach_reverse(row; 0..h)
      s ~= _buf[row].map!`a.rgbs.join(" ")`.join(" ") ~ "\n";
    return s;
  }
}
