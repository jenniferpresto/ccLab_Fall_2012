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
 * THIS VERSION COMMENTS OUT ALL AVERAGING AND DOES NOT CHANGE        *
 * TO CONFORM TO ALL CURRENT VARIABLE NAMES                           *
 * ANIMATION IS THEREFORE SOMEWHAT JERKY                              *
 *                                                                    *
 **********************************************************************
 */
import processing.serial.*;
Serial myPort;

float xPos;
float yPos;

int numSensors = 2; // here using photocell and button, so two sensors
int[] displayArduinoVal = new int[numSensors]; // global variable to read variables from serialEvent method

//int photoDataPoints = 6;
//int[] photoVal = new int[dataPoints]; //will average data from photocell
//float averageVal; // will be the average of the photoVal array

void setup() {
  size(500, 500);
  println(Serial.list());
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n'); // runs serialEvent() method only when get a new line
  background(106, 33, 67);
  smooth();
  //  // initialize all elements of sensorVal array to 0  
  //  for (int i=0; i<dataPoints; i++) {
  //    sensorVal[i] = 0;
  //  }
}
void draw() {
  xPos = width/2; // x-position is the same, night or day

  //daytime animation (button not pressed)
  if (displayArduinoVal[1] == 0) {
    yPos = height - map(displayArduinoVal[0], 120, 780, 0, height);
    noStroke();
    fill(203, 199, 41);
    background(106, 33, 67);
    ellipse(xPos, yPos, 10, 10);
  }
  //nighttime animation (button pressed)
  if (displayArduinoVal[1] == 1) {
    yPos = map(displayArduinoVal[0], 120, 780, 0, height);
    noStroke();
    fill(242, 239, 203);
    background(17, 23, 46);
    ellipse(xPos, yPos, 10, 10);
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
  //  //create an array that constantly shifts to store the last
  //  //batch of data points from the sensor
  //  for (int i=0; i<sensorVal.length-1; i++) {
  //    sensorVal[i] = sensorVal[i+1];
  //  }
  //  sensorVal[sensorVal.length-1]=myPort.read();
  //
  //  //average the value of all those points with function below
  //  average();
  //  
  //  print("The average of the values is ");
  //  println(averageVal);
}


//// function to calculate average of all values of sensorVal
//
//void average() {
//  float total = 0;
//  for (int j=0; j<sensorVal.length; j++) {
//    total += sensorVal[j];
//  }
//  averageVal = total/sensorVal.length;
//}

