module xpx.two.shape;
@safe:

import std;
import xpx.two.vec2;

alias Pt2 = Vec2;

struct Rect {
  Vec2 lb, rt;
}

struct Circle {
  Vec2 c;
  real r;
}

struct Line2 {
  Vec2 orig, dir;

  static Line2 from(Vec2 begin, Vec2 end) => Line2(begin, end-begin);

  auto xmin() const => orig.x < dir.x ? orig : dir;
  auto xmax() const => orig.x > dir.x ? orig : dir;
  auto ymin() const => orig.y < dir.y ? orig : dir;
  auto ymax() const => orig.y > dir.y ? orig : dir;
}

struct Trigon2 {
  Vec2[3] pts;
  Vec2[3] _memo;

  this(Vec2 a, Vec2 b, Vec2 c) {
    pts = [a, b, c];
    _memo[0] = a-b;
    _memo[1] = b-c;
    _memo[2] = c-a;
  }

  bool isIn(Pt2 p) => (cross(_memo[0], pts[0]-p) > 0 &&
                       cross(_memo[1], pts[1]-p) > 0 &&
                       cross(_memo[2], pts[2]-p) > 0);
}

unittest {
  assert(Line2.from(Vec2(1, 2), Vec2(3, 5)).dir == Vec2(2, 3));
  auto r = Rect(Vec2(0, 0), Vec2(100, 100));
}
