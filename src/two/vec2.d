module xpx.two.vec2;
@safe:

import std;
import xpx.lib.utils;

alias Pt2 = Vec2;
alias Vec2 = _Vec2!real;

struct _Vec2(Value) {
  Value[2] _data;

  this(inout Value[] init) { _data = init; }
  this(Value x, Value y) { _data = [x, y]; }

  auto x() const => _data[0];
  auto y() const => _data[1];

  auto lenSq() const {
    auto x_ = x.to!real,
         y_ = y.to!real;
    return x_*x_ + y_*y_;
  }
  auto len() const => lenSq.sqrt;
  auto unit() const => this / len;

  auto opEquals(T: _Vec2!U, U)(auto ref T rhs) const {
    return _data[].map!(to!U).array[] == rhs._data[];
  }

  auto opAssign(T: _Vec2!_, _)(auto ref T rhs) {
    _data[] = rhs._data.toa!Value[];
    return this;
  }

  auto opOpAssign(string op, T)(T rhs) {
    _data[] = mixin("_data[]"~op~"rhs.to!Value");
    return this;
  }
  auto opOpAssign(string op, T: _Vec2!_, _)(T rhs) {
    _data = mixin("_data[]"~op~"rhs._data.toa!Value[]");
    return this;
  }

  auto opUnary(string op)() const => _Vec2!Value(_data[].map!(op~"a").array);

  auto opBinary(string op, T)(T rhs) const {
    T[2] buf = mixin("_data.toa!T[]"~op~"rhs");
    return _Vec2!T(buf);
  }
  auto opBinary(string op, T: _Vec2!U, U)(auto ref T rhs) const
   if(op == "+" || op == "-") {
    U[2] buf = mixin("_data.toa!U[]"~op~"rhs._data[]");
    return _Vec2!U(buf);
  }

  auto opBinaryRight(string op, T)(T lhs) const {
    Value[2] buf = mixin("lhs"~op~"_data[]");
    return _Vec2!Value(buf);
  }

  auto toString() const => "("~_data.toa!string.join(", ")~")";
}

auto dot(T: _Vec2!_T, U: _Vec2!_U, _T, _U)(auto ref T a, auto ref U b) => (a.x * b.x) + (a.y * b.y);

unittest {
  auto a = Vec2([3, 4]);
  auto b = _Vec2!int(1, 1);

  assert(a.len == 5 &&
         b.len == sqrt(2.) &&
         a.unit == Vec2(.6, .8));           // len, unit
  assert((a - 2.) == Vec2(1, 2));           // opBinary, opEquals
  assert((b = -b) == Vec2(-1, -1));         // opAssign, opUnary
  assert((b += 2) == Vec2(1, 1));           // opOpAssign
  assert((a -= Vec2(1, 1)) == Vec2(2, 3));  // opOpAssign(vec)
  assert(a - (2 + b) == Vec2(-1, 0));       // opBinary(vec), opBinaryRight
  assert(b.to!string == "(1, 1)");          // toString
  assert(dot(a, b) == 5);                   // dot
}
