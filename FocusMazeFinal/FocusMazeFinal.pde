
/*
******************************************************************************
 * Focus Maze                                                                 *
 * Jennifer G. Presto                                                         *
 * December 17, 2012                                                          *
 *                                                                            *
 * CCLab Final                                                                *
 *                                                                            *
 * Use a red wand (or calibrate to the color of your choice) to move Sam      *
 * to the exit without touching any of the obstacles or the walls.            *
 *                                                                            *
 * Game grows harder as movement changes and distracting information appears. *
 *                                                                            *
 * Acknowledgements:                                                          *
 * Color tracker adapted from example by Daniel Shiffman, available here:     *
 * http://www.learningprocessing.com/examples/chapter-16/example-16-11/       *
 *                                                                            *
 * Color extraction from Processing example FrameDifferencing, by Golan Levin *
 *                                                                            *
 * Scrolling weather adapted from example by Daniel Shiffman, available here: *
 * http://www.learningprocessing.com/examples/chapter-17/example-17-3/        *
 *                                                                            *
 * Level ArrayLists inspired by conversations with Matt Griffis and           *
 * his notKirby sketch, available here:                                       *
 * https://github.com/jmatthewgriffis/notKirby/tree/master/game               *
 *                                                                            *
 * Twitter search code adapted from RobotGrrl.com                             *
 * Code license under: CC-BY                                                  *
 *                                                                            * 
 * Source code available here:                                                *
 * http://robotgrrl.com/blog/2011/02/21/simple-processing-twitter/            *
 *                                                                            *
 * Note that this uses an older version of the Twitter4j library              *
 * than currently available on twitter4j.org.                                 *
 *                                                                            *
 * This version improves the progression of levels and difficulty.            *
 *                                                                            *
 ******************************************************************************
 */

import processing.video.*;
import com.onformative.yahooweather.*;


int gameState;        // where we are in the game
int subState;         // splitting game states more finely
int round;            // how far the player has gotten
Level level;          // what level is showing
int levelNumber;      // for picking new levels
boolean pickUD;       // for picking up-down motion of new levels
boolean pickLR;       // for picking left-right motion of new levels

Capture video;        // camera object; follows red wand
Dot dot;              // this is you
PImage target;        // this is the item you control with the wand
PImage mirror;        // mirror image for calibration stage
PImage happyYou;      // character while playing
PImage sadYou;        // character when you hit a wall
int buffer;

PImage calibration;
PImage bricks;
PImage clouds;

PImage titlePage;
PImage instruction1;
PImage instruction2;
PImage instructionLevel2;
PImage allBetsOff;

YahooWeather weather;        // weather report
int updateIntervalMillis;    // interval for updating the weather
// collection of locations to use
int[] woeid = {
  2459115, 2483145, 2381457, 753692, 2423945, 2269179, 24865698, 2465512, 615702
};
int woeidIndex;
int weatherX;          // x coordinate of weather information

Twitter twitter = new TwitterFactory().getInstance(); // twitter feed
int numTweets = 9;     // number of tweets to pull with each search
String[] user = new String[numTweets];
String[] latestTweet = new String[numTweets];
int lastTwitterUpdateTime;
int twitterUpdateInterval;
int whatTwitterSearch; // will randomly determine what word to search for
String queryStr;       // word to search Twitter for

int loc;              // global variable for testing all pixels
float closest;        // will be the "distance" from the tracked color
int closestX = 0;     // x coordinate of closest pixel
int closestY = 0;     // y coordinate of closest pixel

color currentColor;   // testing all the pixels each frame

color trackedColor;   // which color pixel to track (defaults to red)

boolean started;      // whether each level has started
boolean collide;      // collision detection
boolean nextLevel;    // whether new level parameters have been determined

int lastStartTime;    // variables for starting each level
int startTimeCurrent;

PFont timerFont;
PFont instructionFont;
PFont smallestFont;
PFont twitterFont;


void setup() {
  size(640, 480, P2D);
  frameRate(30);

  video = new Capture(this, width, height);
  video.start();

  gameState = 0;                    // start with the instructions
  subState = 0;
  round = 1;
  dot = new Dot(width/2, height/2); // always start in the middle

  updateIntervalMillis = 30000;     // updates every 30 seconds
  woeidIndex = 0;
  weather = new YahooWeather(this, woeid[woeidIndex], "f", updateIntervalMillis);
  weatherX = width; // initializing so starts offscreen

  connectTwitter();
  lastTwitterUpdateTime = millis();
  twitterUpdateInterval = 10000;    // new twitter search every 10 seconds

  //  The following items are all initialized in the keyPressed function below
  //  levelNumber = 1;
  //  level.setUpLevel();

  // These items need to be initialized immediately for calibration.

  pickUD = true;
  pickLR = true;
  // first level, which will always be level 1, no reversing
  level = new Level(levelNumber, pickUD, pickLR);

  target = loadImage("target.png");      // this is what you control
  happyYou = loadImage("happyYou.png");  // when playing
  sadYou = loadImage("sadYou.png");      // when losing
  buffer = 2;                            // this is the amount of extra space

  calibration = loadImage("calibrationTitles.png");
  bricks = loadImage("bricks.jpg");
  clouds = loadImage("clouds.png");      // cloudy cover for each level

  titlePage = loadImage("titlePage.png");
  instruction1 = loadImage("instruction1.png");
  instruction2 = loadImage("instruction2.png");
  instructionLevel2 = loadImage("instructionLevel2.png");
  allBetsOff = loadImage("allBetsOff.png");

  background(255);  
  ellipseMode(CENTER);
  imageMode(CENTER);
  rectMode(CENTER);
  textAlign(CENTER);

  trackedColor = color(255, 0, 0); // starts off tracking the reddest pixel

  timerFont = loadFont("Helvetica-Bold-64.vlw");
  instructionFont = loadFont("Helvetica-Bold-32.vlw");
  smallestFont = loadFont("Helvetica-Bold-18.vlw");
  twitterFont = loadFont("Helvetica-Bold-14.vlw");
  smooth();
}

void draw() {

  println("GameState: " + gameState + "; subState: " + subState);
  weather.update();

  // GAMESTATE 0: INSTRUCTIONS -------------
  if (gameState == 0 && subState == 0) {
    image(titlePage, width/2, height/2);
  }
  if (gameState == 0 && subState == 1) {
    image(instruction1, width/2, height/2);
  }
  if (gameState == 0 && subState == 2) {
    image(instruction2, width/2, height/2);
  }

  // GAMESTATE 1: CALIBRATE THE WAND ------------
  if (gameState == 1) {

    // function to track pixel of selected color
    pixelTrack();

    // display simple mirror for calibrating the controller
    loadPixels(); // all pixels of display window
    for (int x = 0; x < video.width; x++) {
      for (int y = 0; y < video.height; y++) {
        pixels[video.width - x - 1 + y * video.width] = video.pixels[x + y * video.width];
      }
    }
    updatePixels(); // updates pixels in display window

    // draw a little square around pixel closest to calibrated color
    noFill();
    stroke(0);
    image(target, closestX, closestY, 50, 50);
    dot.move();
    dot.display();
    image(calibration, width/2, height/2, width, height);
  } // end of gameState 1


  // GAMESTATE 2: STARTING AND PLAYING GAME ------------
  if (gameState == 2) {

    // track pixel of selected color
    pixelTrack();

    // display the current level
    level.display();

    // draw the target around pixel closest to calibrated color
    image(target, closestX, closestY, 50, 50);

    //move Sam to follow the target
    dot.move();
    dot.display();

    // Gameplay now depends on whether the game has STARTED.
    // Player must hover in the white box at the bottom left corner for three seconds
    // to actually start to play.
    if (!started) {
      if ((dot.x > 40 + dot.d * 0.5) && (dot.x < 110 - dot.d * 0.5) && (dot.y > 370 + dot.d * 0.5) && (dot.y < 440 - dot.d * 0.5)) {
        startTimeCurrent = millis() - lastStartTime;
        fill(255);
        textAlign(CENTER);
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

    if (started && millis() - lastStartTime > 3000 && millis() - lastStartTime < 4000) {
      textFont(timerFont);
      fill(255);
      textAlign(CENTER);
      text("Go!", width/2, height/2);
    }

    //collision detection (only after round has started)
    for (int i=0; i<level.layout.size(); i++) { // iterate through all Obstacles, including walls
      // see if Dot is hitting any of them
      Obstacle testHit = (Obstacle) level.layout.get(i); // pull each Obstacle from level to test
      if (dot.x + ((dot.d * 0.5) - buffer) > testHit.x && dot.x - ((dot.d * 0.5) - buffer)  < testHit.x + testHit.w && dot.y + ((dot.d * 0.5)-buffer) > testHit.y && dot.y - ((dot.d * 0.5)-buffer)  < testHit.y + testHit.h) {
        if (started) {
          collide = true;
          println("ouch!");
          gameState = 3;
        }
      }
    }

    //making it to the exit (only after round has started)
    if (dot.x > 600 && dot.y + (dot.d * 0.5) < 120 && dot.y - (dot.d * 0.5) > 40 && started && !collide) {
      round++;
      gameState = 4;
    }
  } // end of gameState 2

  // GAMESTATE 3: YOU LOSE -------------
  if (gameState == 3) {
    level.display();
    noStroke();
    dot.display();
    fill(100, 100, 100, 150);
    rect(0, 0, width, height);
    fill(255);
    textAlign(CENTER);
    textFont(instructionFont);
    text("Ouch!  You hit the wall!", width/2, height/2);
    text("Press the space bar to start over", width/2, height/2 + 30);
    text("with normal movement.", width/2, height/2 + 60);
    subState = 0;
  }

  // GAMESTATE 4: YOU WIN; GO TO NEXT ROUND -------------
  if (gameState == 4) {
    // reset everything for the next round
    // (just once, hence the boolean nextLevel)

    // if it's the first time, level 1,
    // all mostion reversed

    if (!nextLevel && round == 2) {
      //      nextLevel = true;
      pickUD = false;
      pickLR = false;
      level = new Level(1, pickUD, pickLR);
      level.setUpLevel();
      image(instructionLevel2, width/2, height/2);
    }

    // tell player all bets are off

    else if (!nextLevel && round > 2 && subState == 0) {

      image(allBetsOff, width/2, height/2);
    }

    // set up next level and start again

    else if (!nextLevel && round > 2 && subState == 1) {

      determineNextLevel();
      nextLevel = true;

      // tell the player what the level will be
      background(255);
      fill(100);
      textAlign(CENTER);
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
    }
  } // end of gameState 4
} // end of draw function

// Initial Twitter connection
void connectTwitter() {
}


void determineNextLevel() {
  levelNumber = int(random(2, 5)); // depends on how many levels there are; don't pick level 1 again
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

  if (key == ' ' && gameState == 0 && subState == 0) {
    subState = 1;
  } 

  else if (key == ' ' && gameState == 0 && subState == 1) {
    subState = 2;
  } 

  else if (key == ' ' && gameState == 0 && subState == 2) {
    gameState = 1;
    subState = 0;
  } 

  else if (key == ' ' && (gameState == 1 || gameState == 3)) {
    gameState = 2;
    round = 1;
    collide = false;
    started = false; // no collisions until the game officially begins
    nextLevel = false; // allows next level to be picked in case of a win
    level = new Level(1, true, true); // always starts over with easiest level, normal movement
    level.setUpLevel();
    dot.x = width/2;
    dot.y = height/2;
  }

  else if (key == ' ' && gameState == 4 && subState == 0) {
    subState = 1;
  }

  else if (key == ' ' && gameState == 4 && subState == 1) {
    gameState = 2;
    started = false;
    nextLevel = false; // allows new level to be picked in case of a win
    dot.x = width/2;
    dot.y = height/2;
  }
}


void mousePressed() {
  // for calibration in gameState 1; uses mirror of video image
  if (gameState == 1) {
    int loc = video.width - mouseX - 1 + mouseY*video.width;
    trackedColor = video.pixels[loc];
  }
}

void pixelTrack() {
  if (video.available()) {
    video.read();
  }
  closest = 500; //set high; easy for first pixel to beat it
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
      currentColor = video.pixels[loc];

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

      if (d < closest) {
        closest=d;
        closestX = x;
        closestY = y;
      }
    }
  }
}

