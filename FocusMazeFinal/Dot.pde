// this is the player

class Dot {
  float x, y; //position
  float d; //diameter
  float speed;

  Dot(float _x, float _y) {
    x = _x;
    y = _y;
    d = 10;
    speed = 3;
  }

  void move() {
    if (x < closestX) {
      x+=speed;
    }
    if (x > closestX) {
      x -= speed;
    }
    if (y < closestY) {
      y += speed;
    }
    if (y > closestY) {
      y -= speed;
    }
  }

  void display() {
    ellipse(x, y, d, d);
  }
}

