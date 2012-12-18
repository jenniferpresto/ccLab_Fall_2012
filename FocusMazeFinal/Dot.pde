// this is Sam

class Dot {
  float x, y; //position
  float d; //diameter
  float speed;

  Dot(float _x, float _y) {
    x = _x;
    y = _y;
    d = 25;
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
    if (gameState != 3) {
      image(happyYou, x, y, d, d);
    }
    if (gameState == 3) {
      image(sadYou, x, y, d, d);
    }
  }
}

