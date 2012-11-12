class Obstacle {
  float x, y, w, h; // position and size
  color c; // display color
  
  Obstacle(float _x, float _y, float _w, float _h, color _c){
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    c = _c;
  }
  
  void display(){
    rectMode(CORNER);
    noStroke();
    fill(c);
    rect(x, y, w, h);
  }
}
