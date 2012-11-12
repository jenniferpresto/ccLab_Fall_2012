
/*
******************************************************************************
 * Focus Maze                                                                 *
 * Jennifer G. Presto                                                         *
 * November 13, 2012                                                          *
 *                                                                            *
 * CCLab midterm                                                              *
 *                                                                            *
 * Use a red wand to move your dot to the exit                                *
 * without touching any of the obstacles or the walls                         *
 *                                                                            *
 * Acknowledgements:                                                          *
 * color tracker adapted from example by Daniel Shiffman, available here:     *
 * http://www.learningprocessing.com/examples/chapter-16/example-16-11/       *
 *                                                                            *
 * Color extraction from Processing example FrameDifferencing, by Golan Levin *
 *                                                                            *
 * Level ArrayLists inspired by conversations with Matt Griffis and           *
 * his notKirby sketch, available here:                                       *
 * https://github.com/jmatthewgriffis/notKirby/tree/master/game               *
 *                                                                            *
 * This version includes four levels.                                         *
 ******************************************************************************
 */

import processing.video.*;

int gameState;      // where we are in the game
int round;          // how far the player has gotten
Level level;        // what level is showing
int levelNumber;    // for picking new levels
boolean pickUD;     // for picking up-down motion of new levels
boolean pickLR;     // for picking left-right motion of new levels

Capture video;      // camera object; follows red wand
Dot dot;            // this is you

int loc;            // global variable for texting all pixels
int reddestX = 0;   // x coordinate of reddest pixel
int reddestY = 0;   // y coordinate of reddest pixel

color trackedColor; // which color pixel to track (i.e., red)

boolean started;    // whether each level has started
boolean collide;    // collision detection
boolean nextLevel;  // whether new level parameters have been determined

int lastStartTime;  // variables for starting each level
int startTimeCurrent;

PFont timerFont;
PFont instructionFont;
PFont smallestFont;


void setup() {
  size(640, 480, P2D);
  frameRate(30);

  video = new Capture(this, width, height);
  video.start();

  gameState = 0; // start with the instructions
  round = 1;
  dot = new Dot(width/2, height/2); // always start in the middle

  //  The following items are all initialized in the keyPressed function below
  //  levelNumber = 1;
  //  pickUD = true;
  //  pickLR = true;
  //  level = new Level(levelNumber, pickUD, pickLR); // first level, which will always be level 1, no reversing
  //  level.setUpLevel();

  background(255);  
  ellipseMode(CENTER);
  rectMode(CENTER);
  textAlign(CENTER);

  trackedColor = color(255, 0, 0); // will track reddest pixel

  timerFont = loadFont("Helvetica-Bold-64.vlw");
  instructionFont = loadFont("Helvetica-Bold-32.vlw");
  smallestFont = loadFont("Helvetica-Bold-18.vlw");
}

void draw() {
  // Keeping track of what's going on
  //  println("Game State: " + gameState + "    Level: " + level.whichLevel + "   number of Obstacles:" + level.layout.size());

  // GAMESTATE 0: INSTRUCTIONS -------------
  if (gameState == 0) {
    background(255);
    fill(0);
    textFont(instructionFont);
    text("Welcome to the Focus Maze.", width/2, 40);
    text("Move the wand to direct the red dot.", width/2, 70);
    text("For your first level,", width/2, 120);
    text("the dot will move with your wand.", width/2, 150);
    text("After that,", width/2, 180);
    text("up/down or left/right motions", width/2, 210);
    text("may be reversed.", width/2, 240);
    text("Don't hit the obstacles.", width/2, 290);
    text("Hold the dot in the white square", width/2, 340);
    text("to start the game.", width/2, 370);
    text("Hit the space bar to begin.", width/2, 420);
  }

  // GAMESTATE 1: STARTING AND PLAYING GAME ------------
  if (gameState == 1) {
    if (video.available()) {
      video.read();
      //    image(video, 0, 0);

      float reddest = 500; //set high; easy for first pixel to beat it
      video.loadPixels();

      // loop through all the pixels to find x and y coordinates
      for (int x=0; x<video.width; x++) {
        for (int y=0; y<video.height; y++) {

          // adjust which pixel corresponds to location implement mirror
          if (level.normalUD && level.normalLR) {
            loc = (video.width - x - 1)+y*video.width;
          }
          if (level.normalUD && !level.normalLR) {
            loc = x + y*video.width;
          }
          if (!level.normalUD && level.normalLR) {
            loc = (video.width - x - 1) +(video.height - y - 1) * video.width;
          }
          if (!level.normalUD && !level.normalLR) {
            loc = x + (video.height - y -1) * video.width;
          }

          // color of pixel being examined in loop
          color currentColor = video.pixels[loc];

          float r1 = (currentColor >> 16) & 0xFF; // like red(), but faster
          float g1 = (currentColor >> 8) & 0xFF;
          float b1 = currentColor & 0xFF;

          // color of tracked color (originally red)
          float r2 = (trackedColor >> 16) & 0xFF;
          float g2 = (trackedColor >> 8) & 0xFF;
          float b2 = trackedColor & 0xFF;

          // use distance to compare colors
          float d = dist(r1, b1, g1, r2, b2, g2);

          // If currentColor is more similar to tracked Color than the last one,
          // save the x and y coordinates

          if (d < reddest) {
            reddest=d;
            reddestX = x;
            reddestY = y;
          }
        }
      } // end of finding reddest pixel

      // display the current level
      level.display();

      // draw a little square around reddest pixel
      noFill();
      stroke(0);
      rectMode(CENTER); // little square centered around reddest pixel
      rect(reddestX, reddestY, 10, 10);
      fill(255, 0, 0);
      noStroke();

      //move the dot to follow the square
      dot.move();
      dot.display();

      // Gameplay now depends on whether the game has STARTED.
      // Player must hover in the white box at the bottom left corner for three seconds
      // to actually start to play.
      if (!started) {
        if ((dot.x > 40 + dot.d * 0.5) && (dot.x < 110 - dot.d * 0.5) && (dot.y > 370 + dot.d * 0.5) && (dot.y < 440 - dot.d * 0.5)) {
          startTimeCurrent = millis() - lastStartTime;
          textFont(timerFont);
          if (startTimeCurrent < 1000) {
            text("3", width/2, height/2);
          }
          if (startTimeCurrent >= 1000 && startTimeCurrent < 2000) {
            text("2", width/2, height/2);
          }
          if (startTimeCurrent >= 2000 && startTimeCurrent < 3000) {
            text("1", width/2, height/2);
          }
          if (startTimeCurrent >= 3000) {
            started = true;
          }
        } 
        else {
          lastStartTime = millis();
        }
      }

      //collision detection (only after round has started)
      for (int i=0; i<level.layout.size(); i++) { // iterate through all Obstacles, including walls
        // see if Dot is hitting any of them
        Obstacle testHit = (Obstacle) level.layout.get(i); // pull each Obstacle from level to test
        if (dot.x + (dot.d * 0.5) > testHit.x && dot.x - (dot.d * 0.5)  < testHit.x + testHit.w && dot.y + (dot.d * 0.5) > testHit.y && dot.y - (dot.d * 0.5) < testHit.y + testHit.h) {
          if (started) {
            collide = true;
            println("ouch!");
            gameState = 2;
          }
        }
      }

      //making it to the exit (only after round has started)
      if (dot.x > 600 && dot.y + (dot.d * 0.5) < 120 && dot.y - (dot.d * 0.5) > 40 && started && !collide) {
        round++;
        gameState = 3;
      }
    }
  }

  // GAMESTATE 2: YOU LOSE -------------
  if (gameState == 2) {
    level.display();
    noStroke();
    fill(43, 75, 67); // turn circle green
    ellipse(dot.x, dot.y, dot.d, dot.d);
    fill(255);
    textFont(instructionFont);
    text("Ouch!  You hit the wall!", width/2, height/2);
    text("Press the space bar to start over", width/2, height/2 + 30);
    text("with normal movement.", width/2, height/2 + 60);
  }

  // GAMESTATE 3: YOU WIN; GO TO NEXT ROUND -------------
  if (gameState == 3) {
    // reset everything for the next round (just once)
    if (!nextLevel) {
      determineNextLevel();
      nextLevel = true;
    }

    // tell the player what the level will be
    background(255);
    fill(100);
    textFont(instructionFont);
    text("Congratulations!", width/2, 60);
    text("Get ready for the next round!", width/2, 100);
    text("In the next round", width/2, 140);
    text("Your up-down motion will be", width/2, 180);
    fill(98, 102, 167);
    if (pickUD) {
      text("Normal", width/2, 230);
    }
    if (!pickUD) {
      text("Reversed", width/2, 230);
    }
    fill(100);
    text("Your left-right motion will be", width/2, 280);
    fill(98, 102, 167);
    if (pickLR) {
      text("Normal", width/2, 330);
    }
    if (!pickLR) {
      text("Reversed", width/2, 330);
    }
    fill(100);
    text("Hit the space bar to continue.", width/2, 380);
  } // end of gameState 3
}


void determineNextLevel() {
  levelNumber = int(random(1, 5)); // depends how many levels
  if (int(random(0, 2)) == 0) {
    pickUD = true;
  } 
  else {
    pickUD = false;
  }
  if (int(random(0, 2)) == 0) {
    pickLR = true;
  } 
  else {
    pickLR = false;
  }
  level = new Level(levelNumber, pickUD, pickLR); // create a brand new arrayList
  level.setUpLevel(); // set up the new level
}


void keyPressed() {
  if (key == ' ' && (gameState == 0 || gameState == 2)) {
    gameState = 1;
    round = 1;
    collide = false;
    started = false; // no collisions until the game officially begins
    nextLevel = false; // allows next level to be picked in case of a win
    level = new Level(1, true, true); // always starts over with easiest level, normal movement
    level.setUpLevel();
    dot.x = width/2;
    dot.y = height/2;
  }

  if (key == ' ' && gameState == 3) {
    gameState = 1;
    started = false;
    nextLevel = false; // allows new level to be picked in case of a win
    dot.x = width/2;
    dot.y = height/2;
  }
}

