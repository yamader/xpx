module xpx.img.pnm;
@safe:

import std;
import xpx.utils;
import xpx.color;
import xpx.img.base;

class PnmImg: Img {
  string _path;
  Color[][] _data;
  size_t _worig, _horig;
  real _xr = 1,
       _yr = 1;

  Color[][] _cache;
  bool _cached;

  this(string path) { _path = path; }

  real w() const => _worig * _xr;
  real h() const => _horig * _yr;

  void scale(real xr, real yr) {
    _xr = xr;
    _yr = yr;
  }
  void scaleAbs(real x, real y) {
    _xr = x / real(_worig);
    _yr = y / real(_horig);
  }

  void load() @system {
    enum Type { PBM, PGM, PPM }

    auto f = File(_path);
    scope(exit) f.close;
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
    auto size = f.readln.chomp.split(" ").toa!size_t;
    _worig = size[0], _horig = size[1];
    // read
    char[] buf;
    auto nums() => buf.chomp.split(" ").filter!`a.length`.array.toa!ubyte;
    final switch(type) with(Type) {
      case PBM: {
        while(f.readln(buf))
          _data ~= nums.map!(i => Color(i ? 255 : 0)).array;
        break;
      }
      case PGM: {
        auto max = f.readln.chomp.to!ubyte;
        while(f.readln(buf))
          _data ~= nums.map!(i => Color(cast(ubyte)(i * 255 / max))).array;
        break;
      }
      case PPM: {
        auto max = f.readln.chomp.to!ubyte;
        while(f.readln(buf))
          _data ~= nums.chunks(3).map!(i =>
            Color(i.map!(j => cast(ubyte)(j * 255 / max)).array)
          ).array;
        break;
      }
    }
  }

  void cache() {
    // update cache when resize image
  }
}
