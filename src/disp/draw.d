module xpx.disp.draw;
@safe:

import std;
import xpx.two;
import xpx.color;
import xpx.disp.base;

// Dispのキーを返す

size_t draw(T...)(Disp disp, T args) {
  auto buf = new Layer(disp.h, disp.w);
  buf.fill(args);
  return disp.push(buf);
}

void fill(Layer layer, Rect rect, Color c) {
  auto w = layer[0].length,
       h = layer.length;
  auto xmin = max(0, rect.lb.x.to!size_t),
       xmax = min(w, rect.rt.x.to!size_t),
       ymin = max(0, rect.lb.y.to!size_t),
       ymax = min(h, rect.rt.y.to!size_t);
  foreach(y; ymin .. ymax) {
    foreach(x; xmin .. xmax) {
      layer[y][x] = c;
    }
  }
}

void fill(Layer layer, Circle cir, Color c) {
  auto w = layer[0].length,
       h = layer.length;
  auto xmin = max(0, (cir.c.x - cir.r).to!size_t),
       xmax = min(w, (cir.c.x + cir.r).to!size_t),
       ymin = max(0, (cir.c.y - cir.r).to!size_t),
       ymax = min(h, (cir.c.y + cir.r).to!size_t);
  foreach(y; ymin .. ymax) {
    size_t begin;
    foreach(x; xmin .. xmax) {
      if((Vec2(x, y) - cir.c).len <= cir.r) {
        begin = x;
        goto found;
      }
    }
    continue;
   found:
    size_t end;
    foreach_reverse(x; xmin .. xmax) {
      if((Vec2(x, y) - cir.c).len <= cir.r) {
        end = x;
        break;
      }
    }
    foreach(x; begin .. end+1) {
      layer[y][x] = c;
    }
  }
}

void fill(Layer layer, Trigon2 tr, Color c) {
  auto w = layer[0].length,
       h = layer.length;
  size_t xmin = size_t.max,
         xmax = 0,
         ymin = size_t.max,
         ymax = 0;
  foreach(p; tr.pts) {
    xmin = min(xmin, p.x.to!size_t);
    xmax = max(xmax, p.x.to!size_t);
    ymin = min(ymin, p.y.to!size_t);
    ymax = max(ymax, p.y.to!size_t);
  }
  foreach(y; ymin .. ymax) {
    size_t begin;
    foreach(x; xmin .. xmax) {
      if(tr.isIn(Vec2(x, y))) {
        begin = x;
        goto found;
      }
    }
    continue;
   found:
    size_t end;
    foreach_reverse(x; xmin .. xmax) {
      if(tr.isIn(Vec2(x, y))) {
        end = x;
        break;
      }
    }
    foreach(x; begin .. end+1) {
      layer[y][x] = c;
    }
  }
}
