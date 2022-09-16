module xpx.disp.pnm;
@safe:

import std;
import xpx.color;
import xpx.disp.base;

private class DispPNM: DispFile {
  Layer[size_t] _layers;
  size_t _top;
  size_t _w, _h;

  this() { this(Disp.defWidth, Disp.defHeight); }
  this(size_t w, size_t h) {
    _layers[0] = new Layer(h, w);
    _w = w, _h = h;
  }

  size_t w() const => _w;
  size_t h() const => _h;
  auto ws() const => _w.to!string;
  auto hs() const => _h.to!string;

  // CRUD
  size_t push(Layer buf) {
    _top++;
    _layers[_top] = buf;
    return _top;
  }
  Layer get(size_t key) => _layers[key];
  Layer set(size_t key, Layer buf) => _layers[key] = buf;
  size_t del(size_t key) {
    _layers.remove(key);
    _top = _layers.keys.reduce!max;
    return key;
  }

  Layer merge() {
    // メモ化的なやつしたい
    auto layers = _layers.keys.sort.map!((i) => _layers[i]);
    return layers.reduce!(
      (bg, fg) => zip(bg, fg).map!(
        (horiz) => zip(horiz[]).map!(
          (c) => blend(c[])
        ).array
      ).array
    );
  }

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
    // wip
    return s;
  }
}

class DispPGM: DispPNM {
  this() {}
  this(size_t w, size_t h) { super(w, h); }

  override string writes() {
    string s = "P2\n"~ws~" "~hs~"\n255\n";
    foreach_reverse(row; 0..h)
      s ~= merge[row].map!`a.monos`.join(" ") ~ "\n";
    return s;
  }
}

class DispPPM: DispPNM {
  this() {}
  this(size_t w, size_t h) { super(w, h); }

  override string writes() {
    string s = "P3\n"~ws~" "~hs~"\n255\n";
    foreach_reverse(row; 0..h)
      s ~= merge[row].map!`a.rgbs.join(" ")`.join(" ") ~ "\n";
    return s;
  }
}
