
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
 * color tracker adapted from example by Daniel Shiffman,                     *
 * available here:                                                            *
 * http://www.learningprocessing.com/examples/chapter-16/example-16-11/       *
 *                                                                            *
 * Color extraction from Processing example FrameDifferencing, by Golan Levin *
 *                                                                            *
 * Level ArrayLists inspired by notKirby by Matt Griffis,                     *
 * available here:                                                            *
 * https://github.com/jmatthewgriffis/notKirby/tree/master/game               *
 *                                                                            *
 * this version includes rudimentary collision detection                      *
 ******************************************************************************
 */
import processing.video.*;

int gameState;    // where we are in the game
Level level;      // what level is showing
Capture video;    // following red wand
Dot dot;          // this is you

int reddestX = 0; // x coordinate of reddest pixel
int reddestY = 0; // y coordinate of reddest pixel

color trackedColor; // which color pixel to track (i.e., red)

boolean collide;

void setup() {
  size(640, 480, P2D);
  frameRate(30);

  video = new Capture(this, width, height);
  video.start();

  dot = new Dot(width/2, height/2);
  level = new Level(1, true, true);
  level.setUpLevel(); // set up first level, which will always be level 1, no reversing

  background(255);  
  ellipseMode(CENTER);
  rectMode(CENTER);

  trackedColor = color(255, 0, 0); // will track reddest pixel
}

void draw() {
  //  // INSTRUCTIONS -------------
  //  if (gameState == 0) {
  //  }
  //  
  //  // STARTING GAME ------------
  //  if (gameState == 1){
  //  }

  if (video.available()) {
    video.read();
    //    image(video, 0, 0);

    float reddest = 500; //set high; easy for first pixel to beat it
    video.loadPixels();

    // loop through all the pixels to find x and y coordinates
    for (int x=0; x<video.width; x++) {
      for (int y=0; y<video.height; y++) {
        int loc = x+y*video.width;

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
    }

    // set up, then display the level
    level.display();

    // draw a circle around reddest pixel
    noFill();
    stroke(0);
    rectMode(CENTER); // little rectangle centered around reddest pixel
    rect(reddestX, reddestY, 10, 10);
    fill(255, 0, 0);
    noStroke();

    //move the dot to follow the rectangle
    dot.move();
    dot.display();

    //collision detection
    for (int i=0; i<level.layout.size(); i++) { // iterate through all Obstacles, including walls
      // see if Dot is hitting any of them
      Obstacle testHit = (Obstacle) level.layout.get(i); // pull each Obstacle from level to test
      if(dot.x > testHit.x && dot.x < testHit.x + testHit.w && dot.y > testHit.y && dot.y < testHit.y + testHit.h){
        collide = true;
        println("ouch!");
      }
    }
  }
}

