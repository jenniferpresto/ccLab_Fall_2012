// this version adds obstacles and levels

// color tracker adapted from example by Daniel Shiffman,
// available here:
// http://www.learningprocessing.com/examples/chapter-16/example-16-11/

// Color extraction from Processing example FrameDifferencing, by Golan Levin

import processing.video.*;

Level level;
Capture video;
Dot dot;

int reddestX = 0; // x coordinate of reddest pixel
int reddestY = 0; // y coordinat of reddest pixel

color trackedColor; // which color pixel to track

void setup() {
  size(640, 480, P2D);
  frameRate(30);

  video = new Capture(this, width, height);
  video.start();

  dot = new Dot(width/2, height/2);
  level = new Level(1, true, true);

  background(255);  
  ellipseMode(CENTER);
  rectMode(CENTER);

  trackedColor = color(255, 0, 0); // will track reddest pixel
}

void draw() {
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
    level.setUpLevel();
    level.display();

    // draw a circle around reddest pixel
    noFill();
    stroke(0);
    rect(reddestX, reddestY, 10, 10);
    fill(255, 0, 0);
    noStroke();
    dot.move();
    dot.display();
  }
}

