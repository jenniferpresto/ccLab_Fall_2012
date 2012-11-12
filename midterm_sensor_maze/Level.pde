class Level {
  int whichLevel;
  boolean normalUD;
  boolean normalLR;
  ArrayList layout;

  Level (int _whichLevel, boolean _normalUD, boolean _normalLR) {
    whichLevel = _whichLevel;
    normalUD = _normalUD;
    normalLR = _normalLR;
    layout = new ArrayList();
  }

  void setUpLevel() {
    if (whichLevel == 1) {
      background(100); // gray
      color c = color(227, 133, 225); // pink
      layout.add(new Obstacle(40, 50, 100, 30, c));
    }
  }

  void display() {
    for (int i=0; i<layout.size(); i++) {
      Obstacle eachObstacle = (Obstacle) layout.get(i);
      eachObstacle.display();
    }
  }
}

