module xpx.disp.base;
@safe:

import xpx.color;

interface Disp {
  enum defWidth = 800;
  enum defHeight = 600;

  size_t w() const;
  size_t h() const;
  Color get(size_t x, size_t y) const;
  Color set(T: Color)(size_t x, size_t y, auto ref T c);
}

interface DispFile: Disp {
  void write(string path);
}

interface DispOut: Disp {
  void write();
  void writelo(real hz);
}
