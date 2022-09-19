module xpx.img.base;
@safe:

import xpx.disp.base;

// ラスタ
interface Img {
  real w() const;
  real h() const;

  void scale(real xr, real yr);
  void scaleAbs(real x, real y);

  void load() @system;
}
