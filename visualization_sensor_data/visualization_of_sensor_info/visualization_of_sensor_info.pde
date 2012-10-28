import processing.serial.*;

float xPos = 0;
float yPos = 0;

void setup() {
  size(800, 600);
  println(Serial.list());
  String portName = Serial.list()[0];
  Serial myPort = new Serial(this, portName, 9600);
  background(106, 33, 67);
}
void draw() {
}

void serialEvent(Serial myPort) {
  int sensorVal = myPort.read();
  println(sensorVal);

  yPos = height - map(sensorVal, 0, 255, 0, height);
  stroke(203, 199, 41);
  ellipse(xPos, yPos, 10, 10);
  xPos++;
  if (xPos > width) {
    background(106, 33, 67);
    xPos = 0;
  }
}

