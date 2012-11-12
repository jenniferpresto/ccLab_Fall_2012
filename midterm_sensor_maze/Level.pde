class Level {
  int whichLevel;
  boolean normalUD;
  boolean normalLR;
  ArrayList layout;
  color c;

  Level (int _whichLevel, boolean _normalUD, boolean _normalLR) {
    whichLevel = _whichLevel;
    normalUD = _normalUD;
    normalLR = _normalLR;
    layout = new ArrayList();
    c = color(255, 255, 255); // initialize as white
  }

  void setUpLevel() {
    if (whichLevel == 1) {
      background(100); // gray
      c = color(227, 133, 225); // pink
      setUpWalls();
      layout.add(new Obstacle(40, 50, 100, 30));
    }
  }

  void display() {
    fill(c);
    for (int i=0; i<layout.size(); i++) {
      Obstacle eachObstacle = (Obstacle) layout.get(i);
      eachObstacle.display();
    }
  }
  
  void setUpWalls(){ //these are the same for every level
    layout.add(new Obstacle(0, 0, 20, 480));     // left wall
    layout.add(new Obstacle(20, 0, 620, 20));    // top wall
    layout.add(new Obstacle(620, 80, 20, 380));  // right wall
    layout.add(new Obstacle(20, 460, 620, 20));  // bottom wall
  }
}

