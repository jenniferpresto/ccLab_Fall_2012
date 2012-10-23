/*
*************************************************
* Jennifer Presto                               *
* CCLab Homework                                *
* October 23, 2012                              *
*                                               *
* Assignment to create a Rube                   *
* Goldberg machine:                             *
* Button push triggers LED, which               *
* triggers photosensor, which                   *
* triggers motor, which knocks                  *
* over dominoes, which trigger                  *
* motion detector, which trigger                *
* another LED for the big finish.               *
*                                               *
* Includes debounce code for the                *
* button from the Arduino                       *
* example folders, available here:              *
*                                               *
* http://www.arduino.cc/en//Tutorial/Debounce   *
*                                               *
*************************************************

*/

#include <Servo.h>

const int buttonPin = 2; //number for pushbutton
const int photoPin = A0; //number for Photosensor pin (PWM)
const int motorPin = 9; //number for motor pin (PWM)
const int pirPin = 4; //number for PIR pin

const int ledPin1 = 12; //first LED pin
const int ledPin2 = 13; //second LED pin (big finish) 

Servo littleMotor; //creates servo object to control the little motor

int buttonState = 0; //variable for reading pushbutton state
int lastButtonState = 0; //for debounce code for button
int reading = 0; //for debounce for button
long lastDebounceTime = 0; //for debounce for button
long debounceDelay = 0; // for debounce for button

int motorPos = 0; //variable for controlling motor's position
int photoSensorVal = 0; // for reading photo sensor's input
int pirSensorVal = 0; //for reading PIR sensor's input

//booleans for different stages of the machine
boolean buttonPush = false;
boolean lightOn = false;
boolean photoTrip = false;
boolean motorRun = false;
boolean motionDetect = false;


void setup(){
  Serial.begin(9600);
  Serial.println("Warming up...");
  delay(20000); //for motion sensor to warm up
  Serial.println("Ready!");
  littleMotor.attach(9); //attaches servo on pin 9 to the servo object
  //initialize all the pins
  pinMode(buttonPin, INPUT);
  pinMode(photoPin, INPUT);
  pinMode(motorPin, OUTPUT);
  pinMode(pirPin, INPUT);
  pinMode(ledPin1, OUTPUT);
  pinMode(ledPin2, OUTPUT);
}

void loop(){
  
  //debounce code for button
  reading = digitalRead(buttonPin);
  if (reading != lastButtonState){
    lastDebounceTime = millis();
  }
  if ((millis()-lastDebounceTime) > debounceDelay) {
    buttonState = reading;
  }
  lastButtonState = reading;
  //end of debounce code
  
  //when button pushed, flip boolean
  if (buttonState==1 && !buttonPush) {
    buttonPush = true;
  }
  
  //ideally, when buttonPush boolean flips, would turn on the first LED
  //but abandoned steadily lit LED for now
  //because button mechanism unreliable (even with debounce code)

  if(buttonPush){
    digitalWrite(ledPin1, buttonState);
    lightOn = true;
  }
  
  // when LED light comes on, reads photo sensor
  if(lightOn){
    photoSensorVal = analogRead(photoPin);
  }
  
  // when photosensor is over 800 (LED makes it about 985, dim is at
  // about 735), trips photoTrip boolean
  if (photoSensorVal > 800){
    photoTrip = true;
  }
  
  // when photoTrip boolean is tripped, servo activated
  // moves for one second, trips motorRun boolean
  if (photoTrip && motorRun == false) {
    motorPos = 100;
    littleMotor.write(motorPos);
    delay(3000);
    motorPos = 92;
    littleMotor.write(motorPos);
    motorRun = true;
  }
  
  // when motion sensor is tripped,
  // read sensor and trips boolean
  if (motorRun) {
    pirSensorVal = digitalRead(4);
  }
  
  if(pirSensorVal == 1){
    motionDetect = true;
  }
  
  if(motionDetect){
    digitalWrite(ledPin2, HIGH);
  }
    
  
    
  
  
  

//  Serial.print(buttonState);
//  Serial.print(" ");
//  Serial.println(buttonPush);
//Serial.print("photosensor: ");
//Serial.println(photoSensorVal);
//Serial.print("motor: ");
//Serial.println(motorPos);
Serial.print("motion sensor: ");
Serial.println(pirSensorVal);
}



