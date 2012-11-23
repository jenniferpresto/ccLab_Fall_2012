class Obstacle {
  float x, y, w, h; // position and size

  Obstacle(float _x, float _y, float _w, float _h) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
  }

  void display() {
    rectMode(CORNER); // only Obstacles use corner mode when displaying
    noStroke();
    rect(x, y, w, h);
  }
}

