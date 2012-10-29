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

float xPos;
float yPos;

int numSensors = 2; // here using photocell and button, so two sensors
int[] displayArduinoVal = new int[numSensors]; // global variable to read variables from serialEvent method

int photoDataPoints = 50; //the longer this number, smoother motion and more delayed response in animation
int[] photoVal = new int[photoDataPoints]; //will average data from photocell
float averageVal; // will be the average of the photoVal array

PImage sun;
PImage moon;

void setup() {
  size(600, 600);
  println(Serial.list());
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n'); // runs serialEvent() method only when get a new line
  sun = loadImage("sun.png");
  moon = loadImage("moon.png");
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

  //average the value of all those elements ofphotoVal with function below
  average();

  //  print("The average of the values is ");
  //  println(averageVal);

  //daytime animation (button not pressed)
  if (displayArduinoVal[1] == 0) {
    yPos = height - map(averageVal, 120, 820, 0, height);
    noStroke();
    fill(203, 199, 41);
    background(106, 33, 67);
    image(sun, xPos, yPos, 150, 150);
  }
  //nighttime animation (button pressed)
  if (displayArduinoVal[1] == 1) {
    yPos = map(averageVal, 120, 820, 0, height);
    noStroke();
    fill(242, 239, 203);
    background(17, 23, 46);
    image(moon, xPos, yPos, 150, 150);
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


// function to calculate average of all values of sensorVal

void average() {
  float total = 0;
  for (int j=0; j<photoVal.length; j++) {
    total += photoVal[j];
  }
  averageVal = total/photoVal.length;
}

