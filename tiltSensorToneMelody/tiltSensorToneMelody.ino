/*
Example code for CCLab using a tilt sensor to trigger a simple melody.
October 16, 2012
 
 Tilt sensor code adapted from Arduino Digital>Button example code,
 available here:  http://www.arduino.cc/en/Tutorial/Button
 
 Melody code adapted from Arduino Digital>toneMelody example code,
 available here: http://arduino.cc/en/Tutorial/Tone
 
 Debouncing code adapted from arduino tutorial webpage,
 available here: http://www.arduino.cc/en/Tutorial/Debounce
 
 The circuit:
 Speaker attached to pin 13.
 Tilt sensor attached to pin 2 with __ resistor.
 
 */


#include "pitches.h"

const int buttonPin = 2;     // the number of the tilt-sensor pin

// debouncing code
long lastDebounceTime = 0;  // the last time the output pin was toggled
long debounceDelay = 10;    // the debounce time; increase if the output flickers
int ledState = HIGH;         // the current state of the output pin
int buttonState;             // the current reading from the input pin
int lastButtonState = LOW;   // the previous reading from the input pin

// notes in the melody:
int melody[] = {
  NOTE_C4, NOTE_G3,NOTE_G3, NOTE_A3, NOTE_G3, 0, NOTE_B3, NOTE_C4 };

// note durations: 4 = quarter note, 8 = eighth note:
int noteDurations[] = {
  4, 8, 8, 4, 4, 4, 4, 4 };

void setup() {
  // initialize the tilt-sensor pin as an input
  pinMode(buttonPin, INPUT);
}

void loop() {
  //read the state of the tilt sensor into a local variable
  int reading = digitalRead(buttonPin);

  // check to see if you just pressed the button 
  // (i.e. the input went from LOW to HIGH),  and you've waited 
  // long enough since the last press to ignore any noise:  

  // If the switch changed, due to noise or pressing:
  if (reading != lastButtonState) {
    //reset the debouncing timer
    lastDebounceTime = millis();
  } 

  if ((millis() - lastDebounceTime) > debounceDelay) {
    // whatever the reading is at, it's been there for longer
    // than the debounce delay, so take it as the actual current state:
    buttonState = reading;
  }

  lastButtonState = reading;

  //end of the debounce code

  // read the state of the sensor value:
  buttonState = digitalRead(buttonPin);

  // check if the sensor is vertical.
  // if it is, the buttonState is HIGH:
  if (buttonState == HIGH) {     
    for (int thisNote = 0; thisNote < 8; thisNote++) {

      // to calculate the note duration, take one second 
      // divided by the note type.
      //e.g. quarter note = 1000/4, eighth note = 1000/8, etc.
      int noteDuration = 1000/noteDurations[thisNote];
      tone(13, melody[thisN  ote], noteDuration);

      int pauseBetweenNotes = noteDuration * 1.30;
      delay(pauseBetweenNotes);
      // stop the tone playing:
      noTone(13);
    }    
  } 
  else {
    noTone(13); 
  }
}





