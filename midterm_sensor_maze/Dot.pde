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
    if (x < reddestX) {
      x+=speed;
    }
    if (x > reddestX) {
      x -= speed;
    }
    if (y < reddestY) {
      y += speed;
    }
    if (y > reddestY) {
      y -= speed;
    }
  }

  void display() {
    ellipse(x, y, d, d);
  }
}

