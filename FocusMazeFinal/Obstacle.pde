class Obstacle {
  float x, y, w, h; // position and size

  Obstacle(float _x, float _y, float _w, float _h) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
  }

  void display() {
    noStroke();
    beginShape();
    texture(bricks);
    vertex(x, y, x, y);
    vertex(x+w, y, x+w, y);
    vertex(x+w, y+h, x+w, y+h);
    vertex(x, y+h, x, y+h);
    endShape();
  }
}

