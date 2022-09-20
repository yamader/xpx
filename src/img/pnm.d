module xpx.img.pnm;
@safe:

import std;
import xpx.utils;
import xpx.color;
import xpx.img.base;

class PnmImg: Img {
  string _path, _pathMask;
  bool _mask;
  Color[][] _data;
  size_t _w, _h;
  real _xr = 1,
       _yr = 1;

  Color[][] _cache;
  bool _cached;

  this(string path) { _path = path; }
  this(string path, string pathMask) {
    _path = path;
    _pathMask = pathMask;
    _mask = true;
  }

  real w() const => _w * _xr;
  real h() const => _h * _yr;

  void scale(real xr, real yr) {
    _xr = xr;
    _yr = yr;
    _cached = false;
    doCache;
  }
  void scaleAbs(real x, real y) {
    _xr = x / real(_w);
    _yr = y / real(_h);
    _cached = false;
    doCache;
  }

  Color[][] data() {
    if(_cached) doCache;
    return _cache;
  }

  void load() @system {
    enum Type { PBM, PGM, PPM }

    auto f = File(_path);
    scope(exit) f.close;
    char[] sbuf;
    _data = [];

    // type
    Type type;
    switch(f.readln.chomp) with(Type) {
      case "P1": type = PBM; break;
      case "P2": type = PGM; break;
      case "P3": type = PPM; break;
      default: throw new Exception("未実装");
    }

    // size
    while(f.readln(sbuf)) if(sbuf[0] != '#') {
      auto a = sbuf.chomp.split(" ").array.toa!size_t;
      _w = a[0], _h = a[1];
      break;
    }

    // data
    ubyte[] buf;
    while(f.readln(sbuf)) {
      if(sbuf[0] != '#')
        buf ~= sbuf.chomp.split(" ").filter!`a.length`.array.toa!ubyte;
    }

    ubyte max;
    if(type == Type.PGM || type == Type.PPM)
      max = buf.pop;
    final switch(type) with(Type) {
      case PBM: {
        _data = buf.chunks(_w).map!(row =>
          row.map!(i => Color(i ? 255 : 0)).array
        ).array.reverse;
        break;
      }
      case PGM: {
        _data = buf.chunks(_w).map!(row =>
          row.map!(i => Color(i * 255 / max)).array
        ).array.reverse;
        break;
      }
      case PPM: {
        _data = buf.chunks(3*_w).map!(row =>
          row.chunks(3).map!(i =>
            Color(i.map!(j => j * 255 / max).array)
          ).array
        ).array.reverse;
        break;
      }
    }

    if(_mask) {
      auto fmask = File(_pathMask);
      scope(exit) fmask.close;

      // validator
      Type mtyp;
      switch(fmask.readln.chomp) with(Type) {
        case "P1": mtyp = PBM; break;
        case "P2": mtyp = PGM; break;
        default: throw new Exception("マスクはP1, P2しか使えない");
      }
      while(fmask.readln(sbuf)) if(sbuf[0] != '#') {
        auto a = sbuf.chomp.split(" ").array.toa!size_t;
        if(_w != a[0] || _h != a[1]) throw new Exception("mask size mismatch");
        break;
      }
      if(mtyp == Type.PGM) fmask.readln; // size

      // data
      ubyte[][] mask;
      buf = [];
      while(fmask.readln(sbuf)) {
        if(sbuf[0] != '#')
          buf ~= sbuf.chomp.split(" ").filter!`a.length`.array.toa!ubyte;
      }
      mask = buf.chunks(_w).array.reverse;
      foreach(y; 0.._h) foreach(x; 0.._w) {
        if(!mask[y][x]) _data[y][x].alpha = 0;
      }
    }

    doCache;
  }

  void doCache() {
    // todo: scaleを反映する
    _cache = _data;
    _cached = true;
  }
}
