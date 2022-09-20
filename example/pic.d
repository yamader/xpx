import xpx;

void main() {
  DispFile d = new DispPPM(100, 100);

  Img f = new PnmImg("draw.pgm");
  f.load;

  enum red = Color(255, 0, 0);
  enum blue = Color(0, 0, 255);
  enum yellow = Color(255, 255, 0);

  d.fill(
    Rect(Vec2(10, 10), Vec2(90, 90)),
    blue);
  d.fill(
    Trigon2(Vec2(15, 15), Vec2(85, 15), Vec2(50, 85)),
    yellow);
  d.fill(
    Circle(Vec2(50, 45), 25),
    red);

  d.place(f, Vec2(20, 20));

  d.write("hoge.ppm");
}
