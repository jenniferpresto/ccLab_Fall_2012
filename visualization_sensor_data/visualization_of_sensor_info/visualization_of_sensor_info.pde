import processing.serial.*;

float xPos;
float yPos;

/* -----
 Need to assign data coming into serial port to a variable:
 Data from photocell is noisy, and goes through cycle of 6 readings,
 only one of which seems to respond to the light.
 Therefore use the average of many bytes to come through, keeping
 the number divisible by six.
 Note: when used 6 data points only, average was very noisy at the bottom.
 Increased to 600 to get much smoother, although delayed, reaction.
 ------ */

int dataPoints = 600;


int[] sensorVal = new int[dataPoints]; //will average data from photocell
float averageVal; // will be the average of the sensorVal array

void setup() {
  size(800, 600);
  println(Serial.list());
  String portName = Serial.list()[0];
  Serial myPort = new Serial(this, portName, 9600);
  background(106, 33, 67);
  smooth();
  // initialize all elements of sensorVal array to 0  
  for (int i=0; i<dataPoints; i++) {
    sensorVal[i] = 0;
  }
}
void draw() {
}

void serialEvent(Serial myPort) {
  //create an array that constantly shifts to store the last
  //batch of data points from the sensor
  for (int i=0; i<sensorVal.length-1; i++) {
    sensorVal[i] = sensorVal[i+1];
  }
  sensorVal[sensorVal.length-1]=myPort.read();

  //average the value of all those points with function below
  average();
  
  print("The average of the values is ");
  println(averageVal);
  xPos = width/2;
  yPos = height - map(averageVal, 24, 68, 0, height);
  stroke(203, 199, 41);
  fill(203, 199, 41);
  background(106, 33, 67);
  ellipse(xPos, yPos, 10, 10);
}


// function to calculate average of all values of sensorVal

void average() {
  float total = 0;
  for (int j=0; j<sensorVal.length; j++) {
    total += sensorVal[j];
  }
  averageVal = total/sensorVal.length;
}

