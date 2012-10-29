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
 * Code for differentiating between sensors adapted from              *
 * a combination of the NYU-ITP Physical Computing lab examples,      *
 * available here:                                                    *
 * http://itp.nyu.edu/physcomp/Labs/SerialDuplex                      *
 * and from Arduino Invader by Matt Griffis, available here:          *
 * http://www.openprocessing.org/sketch/77167                         * 
 *                                                                    *
 **********************************************************************
 */

const int buttonPin = 2; // digital input from the button
const int photoPin = A0;
int lightValue;
int buttonValue;

void setup() {
  Serial.begin(9600);
  pinMode(buttonPin, INPUT);
}

void loop() {

  //punctuation method to differentiate photocell from button
  lightValue = analogRead(photoPin); //photocell
  buttonValue = digitalRead(buttonPin);
  Serial.print(lightValue); //print results
  Serial.print(",");
  Serial.print(buttonValue); //print results with carriage return
  Serial.print(",");
  Serial.print('\n');
  delay(10);
}





