/*
Simple Firmata Example
Change the builtin LED state based on mouse position. Since this uses Firmata,
you must define all of the properties here in Processing
-Import both the serial and arduino libraries
-Define an Arduino object
-In setup()
--Connect the arduino object to the correct Serial port 
      **change the number in the[] to match your port  Arduino.list()[0]
--Set the pin at output using arduino.pinMode(ledPin, Arduino.OUTPUT)

- In draw()
--use arduino.digitalWrite(ledPin, Arduino.HIGH) and arduino.digitalWrite(ledPin, Arduino.LOW); 
  to turn the LED ON/OFF

*/


import cc.arduino.*;
import processing.serial.*;

Arduino arduino;
int ledPin = 13; // Change this to the pin your LED is connected to

void setup() 
{
  size(1000, 500);  // Window size
  //printArray(Arduino.list());  // List COM-ports

  // Initialize the Arduino object for communication
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  arduino.pinMode(ledPin, Arduino.OUTPUT);  // Set the LED pin as output
}

void draw() 
{
  background(255);
  line(width/2, 0, width/2, height);  // Draw a line in the middle of the window

  // Control the LED based on the mouse position
  if(mouseX >= width / 2) {
    arduino.digitalWrite(ledPin, Arduino.HIGH);  // Turn on the LED
  } else {
    arduino.digitalWrite(ledPin, Arduino.LOW);  // Turn off the LED
  }
}
