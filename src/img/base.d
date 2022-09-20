module xpx.img.base;
@safe:

import xpx.color;

// ラスタ
interface Img {
  real w() const;
  real h() const;

  void scale(real xr, real yr);
  void scaleAbs(real x, real y);

  Color[][] data();

  void load() @system;
}
