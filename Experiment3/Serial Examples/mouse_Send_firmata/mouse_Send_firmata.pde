/*
Control Servo rotation with MouseX value using Firmata
-Change line 31 to correspond with your correct Serial port

-notice line 35 how the pin is defined for servo control in this library
arduino.pinMode(servoPin, Arduino.SERVO);

-Servo is attached to an external 5V power source to fix problems with 
the Serial port dropping due to power issues
-Once the value is calculated, it is sent to the arduino using the line
arduino.servoWrite(servoPin, servoAngle_value);
This command is also defined by the library

*/


import processing.serial.*;
import cc.arduino.*;

Arduino arduino; // create an Arduino object to connect to the board


// Servo variables
int servoPin = 2;
int servoAngle_value;


// Used for converting from pixels to angles
int minServoAngle = 0;
int maxServoAngle = 180;

void setup() 
{
  size(1000, 500);  // Window size
  printArray(Arduino.list());  // List COM-ports

  // Open the port that the Arduino is connected to (change this to match your setup)

  arduino = new Arduino(this, Arduino.list()[0], 57600);
  
  // Set servo pin as output
  arduino.pinMode(servoPin, Arduino.SERVO);
}

void draw() 
{
  fill(0);
  stroke(0);
  background(255);
  
  // Show which port is connected
  text("Port: "+Arduino.list()[0], 20, 20);

  // Get mouseX and convert it to 0 - 180 as an integer
  servoAngle_value = round(map(mouseX, 0, width, minServoAngle, maxServoAngle));

  // Draw a vertical line and the mouseX location
  line(mouseX, 0, mouseX, height);
  text("mouse: "+mouseX, mouseX + 10, height / 2);
  text("servo: "+servoAngle_value, mouseX + 10, height / 2 + 15);

  // Send the servo angle to the Arduino
  arduino.servoWrite(servoPin, servoAngle_value);
}
