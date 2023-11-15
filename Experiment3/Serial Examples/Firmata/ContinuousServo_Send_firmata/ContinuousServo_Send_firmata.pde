/*
Control a Continuous Servo using Firmata
-Adjust these variable to control the motion/direction of your motor 
int counterClockwise = 180; // Value for counterclockwise rotation
int stop = 92;              // Value for stopping the servo
int clockWise = 0;          // Value for clockwise rotation

Uses StandardFirmata


Changes based on mousePosition


*/


import processing.serial.*;
import cc.arduino.*;

Arduino arduino; // create an Arduino object to connect to the board

// Servo variables
int servoPin = 2;
int counterClockwise = 180; // Value for counterclockwise rotation
int stop = 92;              // Value for stopping the servo
int clockWise = 0;          // Value for clockwise rotation

void setup() {
  size(1000, 500);  // Window size
  printArray(Arduino.list());  // List COM-ports

  // Open the port that the Arduino is connected to (change this to match your setup)
  arduino = new Arduino(this, Arduino.list()[0], 57600);

  // Set servo pin as output
  arduino.pinMode(servoPin, Arduino.SERVO);
}

void draw() {
  background(255);

  // Determine the area of each section
  int leftEnd = width / 3;
  int rightStart = width * 2 / 3;

  // Check which area the mouse is in and set the servo value
  if (mouseX < leftEnd) {
    arduino.servoWrite(servoPin, counterClockwise);
    fillSection(0, leftEnd, "Counter Clockwise");
  } else if (mouseX > rightStart) {
    arduino.servoWrite(servoPin, clockWise);
    fillSection(rightStart, width, "Clockwise");
  } else {
    arduino.servoWrite(servoPin, stop);
    fillSection(leftEnd, rightStart, "Stop");
  }
}

// Function to fill a section and display text
void fillSection(int start, int end, String label) {
  fill(200, 200, 250, 127); // Semi-transparent fill
  rect(start, 0, end - start, height);
  fill(0);
  textAlign(CENTER, CENTER);
  text(label, (start + end) / 2, height / 2);
}
