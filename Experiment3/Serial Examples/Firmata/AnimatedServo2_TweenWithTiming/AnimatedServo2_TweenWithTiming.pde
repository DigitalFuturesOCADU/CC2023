/*
Servo Tween

Utilizes Firmata for Arduino communication, Ani for smooth servo movements, and ControlP5 for interactive controls. 
Adjust servo position interactively with mouse events and control animation speed using a slider.

Arduino setup: Run StandardFirmata sketch.
*/


import processing.serial.*;
import cc.arduino.*;
import de.looksgood.ani.*;
import controlP5.*;

Arduino arduino; // Object for communication with the Arduino board
Ani servoAnimation; // Object for smooth animation
ControlP5 cp5; // Object for the ControlP5 library

// Servo variables
int servoPin = 2; // Pin number where the servo is connected
float servoAngle_value; // Current angle value for the servo
// Used for converting from pixels to angles
int minServoAngle = 0;
int maxServoAngle = 180;
float animatedX; // Animated X position
float targetPixelX; // Target X position for animation
int servoValue; // Value to write to the servo

// Animation speed control
float animationSpeed = 1.0; // Duration for the animation

void setup() {
  size(1000, 500); // Window size
  printArray(Arduino.list()); // Print available COM ports

  // Initialize Arduino connection
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  arduino.pinMode(servoPin, Arduino.SERVO); // Set servo pin as output

  // Initialize Ani library
  Ani.init(this);

  // Initialize ControlP5 and add a slider for animation speed
  cp5 = new ControlP5(this);
  cp5.addSlider("animationSpeed")
     .setPosition(20, 20)
     .setSize(200, 20)
     .setRange(0.1, 10.0)
     .setValue(2.0)
     .setLabel("Animation Speed")
     .getCaptionLabel().setColor(0);
}

void draw() {
  background(255);
  fill(0);
  stroke(0);

  // Calculate the servo value based on the animated X position
  servoValue = round(map(animatedX, 0, width, minServoAngle, maxServoAngle));

  // Draw an ellipse at the target X position
  ellipse(targetPixelX, height / 2, 20, 20);

  // Draw a vertical line at the animated X position
  line(animatedX, 0, animatedX, height);

  // Display the servo value
  text("Servo: " + servoValue, animatedX + 10, height / 2 + 15);

  // Send the servo angle to the Arduino
  arduino.servoWrite(servoPin, servoValue);
}

void mouseReleased() {
  // Set the target X position based on mouse position and start the animation
  targetPixelX = mouseX; 
  Ani.to(this, animationSpeed, "animatedX", targetPixelX);
}

// ControlP5 callback for slider changes
public void controlEvent(ControlEvent event) {
  if (event.isFrom(cp5.getController("animationSpeed"))) {
    // Update the animation speed when the slider value changes
    animationSpeed = event.getValue();
  }
}
