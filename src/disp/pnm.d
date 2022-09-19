module xpx.disp.pnm;
@safe:

import std;
import xpx.color;
import xpx.disp.base;

private class DispPNM: DispFile {
  Layer[size_t] _layers;
  bool[size_t] _show; // 見直す
  size_t _top;
  size_t _w, _h;

  this() { this(Disp.defWidth, Disp.defHeight); }
  this(size_t w, size_t h) {
    _layers[0] = new Layer(h, w);
    _show[0] = true;
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
    _show[_top] = true;
    return _top;
  }
  Layer get(size_t key) => _layers.get(key, _layers[_top]);
  Layer set(size_t key, Layer buf) {
    if(!_show.keys.canFind(key)) _show[key] = true;
    return _layers[key] = buf;
  }
  size_t del(size_t key) {
    _layers.remove(key);
    _show.remove(key);
    _top = _layers.keys.fold!max;
    return key;
  }

  void show(size_t key) { _show[key] = true; }
  void hide(size_t key) { _show[key] = false; }
  bool toggle(size_t key) => _show[key] = !_show[key];

  Layer merge() {
    // メモ化的なやつしたい
    auto keys = _layers.keys.sort.filter!(i => _show[i]);
    auto layers = keys.map!(i => _layers[i]);
    return layers.fold!(
      (bg, fg) => zip(bg, fg).map!(
        (horiz) => zip(horiz[]).map!(
          (c) => blend(c[])
        ).array
      ).array
    );
  }

  void write(string path) {
    fwrite(File(path, "w"), merge);
  }
  abstract void fwrite(File f, Layer layer);
}

class DispPBM: DispPNM {
  this() {}
  this(size_t w, size_t h) { super(w, h); }

  override void fwrite(File f, Layer layer) {
    f.writeln("P1\n"~ws~" "~hs);
    foreach_reverse(y; 0..h) {
      foreach(x; 0..w) {
        f.write("0 ");
      }
      f.writeln;
    }
  }
}

class DispPGM: DispPNM {
  this() {}
  this(size_t w, size_t h) { super(w, h); }

  override void fwrite(File f, Layer layer) {
    f.writeln("P2\n"~ws~" "~hs~"\n255");
    foreach_reverse(y; 0..h) {
      foreach(x; 0..w) {
        f.write(layer[y][x].monos ~ " ");
      }
      f.writeln;
    }
  }
}

class DispPPM: DispPNM {
  this() {}
  this(size_t w, size_t h) { super(w, h); }

  override void fwrite(File f, Layer layer) {
    f.writeln("P3\n"~ws~" "~hs~"\n255");
    foreach_reverse(y; 0..h) {
      foreach(x; 0..w) {
        f.write(layer[y][x].rgbs.join(" ") ~ " ");
      }
      f.writeln;
    }
  }
}
