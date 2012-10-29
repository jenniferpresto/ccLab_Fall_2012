/*
 **********************************************************************
 * Visualization of Photocell Data                                    *
 * Jennifer Presto                                                    *
 * October 29, 2012                                                   *
 *                                                                    *
 * A visualization of information coming from the                     *
 * photocell.  Press the button to see an alternate                   *
 * visualization.                                                     *
 * (Homework for CCLab combining Processing and Arduino).             *
 *                                                                    *
 * Shifting array (to average data points) inspired by                *
 * and adapted from code by Daniel Shiffman, available here:          *
 * http://www.learningprocessing.com/examples/chapter-9/example-9-8/  *
 *                                                                    *
 * Serial communication portions adapted from                         *
 * a combination of the NYU-ITP Physical Computing lab examples,      *
 * available here:                                                    *
 * http://itp.nyu.edu/physcomp/Labs/SerialDuplex                      *
 * and from Arduino Invader by Matt Griffis, available here:          *
 * http://www.openprocessing.org/sketch/77167                         * 
 *                                                                    *
 **********************************************************************
 */
import processing.serial.*;
Serial myPort;

//position of sun and moon
float xPos;
float yPos;

//color of the sky
float dayR, dayG, dayB;
float nightR, nightG, nightB;

// general range of photocell numbers, for easy calibration
float averageBottom = 120;
float averageTop = 820;

int numSensors = 2; // here using photocell and button, so two sensors
int[] displayArduinoVal = new int[numSensors]; // global variable to read variables from serialEvent method

int photoDataPoints = 50; //the longer this number, smoother motion and more delayed response in animation
int[] photoVal = new int[photoDataPoints]; //will average data from photocell
float averageVal; // will be the average of the photoVal array

PImage sun;
PImage moon;
PImage dayScenery;
PImage nightScenery;

void setup() {
  size(600, 600);
  println(Serial.list());
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n'); // runs serialEvent() method only when get a new line
  sun = loadImage("sun.png");
  moon = loadImage("moon.png");
  dayScenery = loadImage("day_scenery.png");
  nightScenery = loadImage("night_scenery.png");
  imageMode(CENTER);
  
  smooth();
  
  // initialize all elements of displayArduinoVal array to 0
  for (int i=0; i<numSensors; i++) {
    displayArduinoVal[i] = 0;
  }

  // initialize all elements of sensorVal array to 0
  for (int i=0; i<photoDataPoints; i++) {  
    photoVal[i] = 0;
  }
}
void draw() {
  xPos = width/2; // x-position is the same, night or day

  //create an array that constantly shifts to store the last
  //batch of data points from the sensor
  for (int i=0; i<photoVal.length-1; i++) {
    photoVal[i] = photoVal[i+1];
  }

  // in final element of photoVal, insert latest reading of photocell,
  // which is always the [0] index element of displayArduinoVal
  photoVal[photoVal.length-1]=displayArduinoVal[0];

  //average the value of all the elements within photoVal with function below
  average();

  //  print("The average of the values is ");
  //  println(averageVal);
  
  //determine color of sky
  dayR = map(averageVal, averageBottom, averageTop, 100, 68);
  dayG = map(averageVal, averageBottom, averageTop, 21, 224);
  dayB = map(averageVal, averageBottom, averageTop, 100, 250);
  
  nightR = map(averageVal, averageBottom, averageTop, 17, 59);
  nightG = map(averageVal, averageBottom, averageTop, 23, 42);
  nightB = map(averageVal, averageBottom, averageTop, 46, 165);

  //daytime animation (button not pressed)
  if (displayArduinoVal[1] == 0) {
    yPos = height - map(averageVal, averageBottom, averageTop, 50, height-50);
    noStroke();
    fill(203, 199, 41);
    background(dayR, dayG, dayB);
    image(sun, xPos, yPos, 150, 150);
    image(dayScenery, width/2, height/2);
  }
  //nighttime animation (button pressed)
  if (displayArduinoVal[1] == 1) {
    yPos = map(averageVal, averageBottom, averageTop, 75, height-50);
    noStroke();
    fill(242, 239, 203);
    background(nightR, nightG, nightB);
    image(moon, xPos, yPos, 150, 150);
    image(nightScenery, width/2, height/2);
  }
}

void serialEvent(Serial myPort) {
  String sensorString = myPort.readStringUntil('\n'); //reads info from Arduino
  //  println(sensorString);
  int arduinoVal[] = int(split(sensorString, ',')); // splits into separate integers
  //  println(arduinoVal.length);

  if (arduinoVal != null) {
    for (int sensorNum = 0; sensorNum < arduinoVal.length; sensorNum++) {
      print("Sensor " + sensorNum + ": " + arduinoVal[sensorNum] + " \t");
    }
    println();
    for (int i=0; i<displayArduinoVal.length; i++) {
      displayArduinoVal[i] = arduinoVal[i];
    }
  }
}

// function to calculate average of all values of photoVal
void average() {
  float total = 0;
  for (int j=0; j<photoVal.length; j++) {
    total += photoVal[j];
  }
  averageVal = total/photoVal.length;
}

