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
      layout.add(new Obstacle(120, 60, 140, 200));
      layout.add(new Obstacle(380, 120, 160, 40));
      layout.add(new Obstacle(320, 280, 240, 80));
    }
  }

  void display() {
    // main part of the level (including walls)
    if (started) {
      background(98, 102, 167);
    }
    if (!started) {
      background(100);
    }
    fill(c);
    noStroke();
    for (int i=0; i<layout.size(); i++) {
      Obstacle eachObstacle = (Obstacle) layout.get(i);
      eachObstacle.display();
    }

    // white start box in bottom left corner of every level
    rectMode(CORNER);
    fill(255);
    stroke(0);
    strokeWeight(2);
    rect(40, 370, 70, 70);
    fill(0);
    textFont(smallestFont);
    text("Round: " + round, 45, 20);
    if (!started) {
      text("<-- Start here!", 175, 405);
    }
    text("Exit -->", 575, 80);
  }

  void setUpWalls() { //these are the same for every level
    layout.add(new Obstacle(0, 0, 40, 480));     // left wall
    layout.add(new Obstacle(40, 0, 600, 40));    // top wall
    layout.add(new Obstacle(600, 120, 40, 320));  // right wall
    layout.add(new Obstacle(40, 440, 600, 40));  // bottom wall
  }
}

