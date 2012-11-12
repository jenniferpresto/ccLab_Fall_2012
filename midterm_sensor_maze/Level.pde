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

    if (whichLevel == 2) {
      background(100); // gray
      c = color(216, 202, 74); // mustard
      setUpWalls();
      layout.add(new Obstacle(80, 160, 200, 60));
      layout.add(new Obstacle(180, 240, 90, 170));
      layout.add(new Obstacle(370, 120, 50, 260));
      layout.add(new Obstacle(500, 80, 40, 60));
      layout.add(new Obstacle(500, 200, 80, 40));
    }

    if (whichLevel == 3) {
      background(100); //gray
      c = color(38, 32, 73); // dark blue
      setUpWalls();
      layout.add(new Obstacle(90, 110, 120, 200));
      layout.add(new Obstacle(280, 60, 210, 190));
      layout.add(new Obstacle(130, 350, 230, 50));
      layout.add(new Obstacle(420, 300, 140, 110));
    }
    
    if (whichLevel == 4) {
      background(100); //gray
      c = color(117, 40, 102); // purple-gray  
      setUpWalls();
      layout.add(new Obstacle(170, 60, 180, 40));
      layout.add(new Obstacle(170, 160, 250, 60));
      layout.add(new Obstacle(70, 290, 320, 50));
      layout.add(new Obstacle(460, 90, 70, 330));
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

