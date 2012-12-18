class Level {
  int whichLevel;
  boolean normalUD;
  boolean normalLR;
  ArrayList layout;
  color c;
  float twitterUserX;
  float twitterUserY;
  float twitterUserW;
  float twitterUserH;
  float tweetX;
  float tweetY;
  float tweetW;
  float tweetH;

  Level (int _whichLevel, boolean _normalUD, boolean _normalLR) {
    whichLevel = _whichLevel;
    normalUD = _normalUD;
    normalLR = _normalLR;
    layout = new ArrayList();
    c = color(255, 255, 255); // initialize as white
  }

  void setUpLevel() {
    getSearchTweets();                 // pull new set of tweets
    lastTwitterUpdateTime = millis();  // reset timer for Twitter feed
    setUpWalls();                      // outer walls same for all levels

      if (whichLevel == 1) {
      twitterUserX = 110;
      twitterUserY = 50;
      twitterUserW = 140;
      twitterUserH = 20;
      tweetX = 110;
      tweetY = 80;
      tweetW = 140;
      tweetH = 150;
      layout.add(new Obstacle(100, 40, 160, 200));
      layout.add(new Obstacle(430, 160, 110, 40));
      layout.add(new Obstacle(390, 280, 170, 100));
    }

    if (whichLevel == 2) {
      twitterUserX = 150;
      twitterUserY = 190;
      twitterUserW = 150;
      twitterUserH = 20;
      tweetX = 150;
      tweetY = 210;
      tweetW = 150;
      tweetH = 140;
      layout.add(new Obstacle(140, 180, 170, 180));
      layout.add(new Obstacle(200, 40, 200, 60));
      layout.add(new Obstacle(390, 160, 40, 60));
      layout.add(new Obstacle(430, 320, 70, 40));
      layout.add(new Obstacle(500, 100, 40, 260));
    }

    if (whichLevel == 3) {
      twitterUserX = 320;
      twitterUserY = 130;
      twitterUserW = 190;
      twitterUserH = 20;
      tweetX = 320;
      tweetY = 150;
      tweetW = 190;
      tweetH = 140;
      layout.add(new Obstacle(310, 120, 210, 180));
      layout.add(new Obstacle(90, 180, 120, 110));
      layout.add(new Obstacle(210, 350, 100, 90));
    }

    if (whichLevel == 4) {
      twitterUserX = 400;
      twitterUserY = 110;
      twitterUserW = 110;
      twitterUserH = 30;
      tweetX = 400;
      tweetY = 150;
      tweetW = 110;
      tweetH = 190;
      layout.add(new Obstacle(40, 230, 100, 50));
      layout.add(new Obstacle(90, 90, 180, 40));
      layout.add(new Obstacle(230, 240, 70, 200));
      layout.add(new Obstacle(390, 100, 130, 250));
    }
  }

  void display() {

    // background color always starts the same;
    // once player starts the level,
    // background color varies depending on the level itself

    if (!started) {
      background(33, 17, 17);
    }

    if (started && (whichLevel == 1 || whichLevel == 3)) {
      background(14, 26, 33);
    }

    if (started && (whichLevel == 2 || whichLevel == 4)) {
      // background(48, 20, 20);
      // background (45, 39, 17); // mossy green
      background (34, 15, 36); // deep purple
    }

    // main part of the level (including walls)

    image(clouds, width/2, height/2);
    noStroke();
    for (int i=0; i<layout.size(); i++) {
      Obstacle eachObstacle = (Obstacle) layout.get(i);
      eachObstacle.display();
    }

    rectMode(CORNER);
    textAlign(CENTER);
    textFont(smallestFont);
    fill(255);

    // white start box in bottom left corner of every level
    // until player starts

    if (!started) {
      stroke(0);
      strokeWeight(2);
      rect(40, 370, 70, 70);
      text("<-- Start here!", 175, 425);
    }

    // explanatory text on the level
    // stays

    text("Round: " + round, 45, 20);
    text("Exit -->", 575, 80);

    // distraction begins only if not one of the 
    // first two rounds and the player has started

    if (round > 2 && started) {
      this.distractionScroll();
      this.twitterDisplay();
    }
  }

  void setUpWalls() {  // outer walls; same for every level
    layout.add(new Obstacle(0, 0, 40, 480));      // left wall
    layout.add(new Obstacle(40, 0, 600, 40));     // top wall
    layout.add(new Obstacle(600, 120, 40, 320));  // right wall
    layout.add(new Obstacle(40, 440, 600, 40));   // bottom wall
  }

  void distractionScroll() {
    textAlign(LEFT);
    //    fill(0);
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
    textFont(twitterFont);
    for (int i = 0; i<numTweets; i++) {
      int currentTwitterTime = millis() - lastTwitterUpdateTime;
      if (i < numTweets - 1 && currentTwitterTime > (i* twitterUpdateInterval) && currentTwitterTime < (i+1) * twitterUpdateInterval) {
        fill(0, 200, 255); 
        text("@" + user[i], twitterUserX, twitterUserY, twitterUserW, twitterUserH); 
        fill(255); 
        text(latestTweet[i], tweetX, tweetY, tweetW, tweetH);
      }
      if (i == numTweets - 1 && currentTwitterTime >= (i+1) * twitterUpdateInterval) {
        fill(0, 200, 255); 
        text("@" + user[i], twitterUserX, twitterUserY, twitterUserW, twitterUserH); 
        fill(255); 
        text(latestTweet[i], tweetX, tweetY, tweetW, tweetH);
      }
    }
  }


  // search for tweets
  void getSearchTweets() {
    whatTwitterSearch = int(random(0, 5));
    if (whatTwitterSearch == 0) {
      queryStr = "balls";
    }
    if (whatTwitterSearch == 1) {
      queryStr = "fiscal cliff";
    }
    if (whatTwitterSearch == 2) {
      queryStr = "boehner";
    }
    if (whatTwitterSearch == 3) {
      queryStr = "coulter";
    }
    if (whatTwitterSearch == 4) {
      queryStr = "obama";
    }
    try {
      Query query = new Query(queryStr);    
      query.setRpp(numTweets); // Get certain number of the 100 search results  
      QueryResult result = twitter.search(query);
      ArrayList tweets = (ArrayList) result.getTweets();    
      for (int i=0; i<tweets.size(); i++) {  
        Tweet t = (Tweet)tweets.get(i);  
        user[i] = t.getFromUser();
        latestTweet[i] = t.getText();

        //      println("@" + user);
        //      println(latestTweet[i]);
      }
    } 
    catch (TwitterException e) {    
      println("Search tweets: " + e);
    }
  }
}
