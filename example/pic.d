import xpx;

void main() {
  DispFile d = new DispPPM(100, 100);

  enum red = Color(255, 0, 0);
  enum blue = Color(0, 0, 255);
  enum yellow = Color(255, 255, 0);

  d.draw(
    Rect(Vec2(10, 10), Vec2(90, 90)),
    blue);
  d.draw(
    Trigon2(Vec2(15, 15), Vec2(85, 15), Vec2(50, 85)),
    yellow);
  d.draw(
    Circle(Vec2(50, 45), 25),
    red);

  d.write("hoge.ppm");
}
