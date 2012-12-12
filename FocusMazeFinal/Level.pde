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
    background(100); //gray
    if (whichLevel == 1) {
      c = color(227, 133, 225); // pink
      setUpWalls();
      layout.add(new Obstacle(120, 60, 140, 200));
      layout.add(new Obstacle(380, 120, 160, 40));
      layout.add(new Obstacle(320, 280, 240, 80));
    }

    if (whichLevel == 2) {
      c = color(216, 202, 74); // mustard
      setUpWalls();
      layout.add(new Obstacle(80, 160, 200, 60));
      layout.add(new Obstacle(180, 240, 90, 170));
      layout.add(new Obstacle(370, 120, 50, 260));
      layout.add(new Obstacle(500, 80, 40, 60));
      layout.add(new Obstacle(500, 200, 80, 40));
    }

    if (whichLevel == 3) {
      c = color(201, 70, 35); // burnt orange
      setUpWalls();
      layout.add(new Obstacle(90, 110, 120, 200));
      layout.add(new Obstacle(280, 60, 210, 190));
      layout.add(new Obstacle(130, 350, 230, 50));
      layout.add(new Obstacle(420, 300, 140, 110));
    }

    if (whichLevel == 4) {
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
    textAlign(CENTER);

    // explanatory text on the level
    text("Round: " + round, 45, 20);
    text("Exit -->", 575, 80);
    // start text only if not yet started level
    if (!started) {
      text("<-- Start here!", 175, 425);
    }
    // scrolling distraction only if not the first round
    // and the level has been started
    if (round > 1 && started) {
      this.distractionScroll();
      this.twitterDisplay();
    }
  }

  void setUpWalls() { //these are the same for every level
    layout.add(new Obstacle(0, 0, 40, 480));     // left wall
    layout.add(new Obstacle(40, 0, 600, 40));    // top wall
    layout.add(new Obstacle(600, 120, 40, 320));  // right wall
    layout.add(new Obstacle(40, 440, 600, 40));  // bottom wall
  }

  void distractionScroll() {
    textAlign(LEFT);
    fill(0);
    text("City: " + weather.getCityName() + "    Temp: " + weather.getTemperature() + " F", weatherX, 465);
    if (gameState==2) { // scrolls only when actively playing
      weatherX-=4;
    }
    // next variable sets width of temperature text
    float w = textWidth("City: " + weather.getCityName() + "    Temp: " + weather.getTemperature() + " F");
    if (weatherX < -w) {
      // cycle through loaded locations
      woeidIndex++;
      weatherX = width;
      weather.setWOEID(woeid[woeidIndex]);
      if (woeidIndex >= woeid.length-1) {
        woeidIndex = -1; // will be incremented to 0 immediately
      }
    }
    //    println(weatherX + " " + weather.getCityName() + "  " + weather.getTemperature());
    //    println(textWidth("City: " + weather.getCityName() + "Temperature: " + weather.getTemperature() + "F"));
  }

  void twitterDisplay() {
    if (millis() -lastTwitterUpdateTime > twitterUpdateInterval) {
      getSearchTweets();
      println(millis() + " " + queryStr);
      lastTwitterUpdateTime = millis();
    }

    fill(0, 200, 255); 
    text("@" + user, 20, 50, width/2 - 60, height - 100); 
    fill(255); 
    text(latestTweet, 20, 150, width/2 - 60, height - 100);
  }
}

// search for tweets
void getSearchTweets() {
  whatTwitterSearch = int(random(0, 5));
  if (whatTwitterSearch == 0) {
    queryStr = "balls";
  }
  if (whatTwitterSearch == 1) {
    queryStr = "testicles";
  }
  if (whatTwitterSearch == 2) {
    queryStr = "vagina";
  }
  if (whatTwitterSearch == 3) {
    queryStr = "vomit";
  }
  if (whatTwitterSearch == 4) {
    queryStr = "Obama";
  }
  try {
    Query query = new Query(queryStr);    
    query.setRpp(1); // Get 1 of the 100 search results  
    QueryResult result = twitter.search(query);
    ArrayList tweets = (ArrayList) result.getTweets();    
    for (int i=0; i<tweets.size(); i++) {  
      Tweet t = (Tweet)tweets.get(i);  
      user = t.getFromUser();
      latestTweet = t.getText();

      println("@" + user);
      println(latestTweet);
    }
  } 
  catch (TwitterException e) {    
    println("Search tweets: " + e);
  }
}

