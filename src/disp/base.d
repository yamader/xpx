module xpx.disp.base;
@safe:

import xpx.color;

alias Layer = Color[][];

interface Disp {
  enum defWidth = 800;
  enum defHeight = 600;

  size_t w() const;
  size_t h() const;

  // CRUD
  size_t push(Layer buf);
  Layer get(size_t key);
  Layer set(size_t key, Layer buf);
  size_t del(size_t key);

  void show(size_t key);
  void hide(size_t key);
  bool toggle(size_t key);
}

interface DispFile: Disp {
  void write(string path);
}

interface DispOut: Disp {
  void write();
  void writelo(real hz);
}
