/*
Example of creating an interactive Servo Animation using Ani and Firmata
It works similar to animated clips in a game engine.
Create the keyframe animation sequence in setup() using seq.add
For library details see: http://www.looksgood.de/libraries/Ani/


The current motion can be changed by adding values to the sequence

Uses StandardFirmata on Arduino

*/



import de.looksgood.ani.*;
import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
AniSequence seq;
int servoPin = 2;
float servoValue = 0;

void setup() {
  size(512, 512);
  smooth();
  noStroke();
  textAlign(CENTER);
  background(255);

  // Arduino setup
  printArray(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  arduino.pinMode(servoPin, Arduino.SERVO);

  // Ani library initialization
  Ani.init(this);

  // Create and configure the animation sequence
  seq = new AniSequence(this);
  seq.beginSequence();
  
  // Animation steps the name in " " must match the name of the variable being animated
  seq.add(Ani.to(this, 0.8, "servoValue", 60));
  seq.add(Ani.to(this, 1, "servoValue", 60));
  seq.add(Ani.to(this, 1, "servoValue", 90));
  seq.add(Ani.to(this, 0.5, "servoValue", 0, Ani.LINEAR, "onEnd:sequenceEnd"));
  
  seq.endSequence();
  seq.start();
}

void draw() {
  background(255);

  // Update the servo position
  arduino.servoWrite(servoPin, round(servoValue));

  // Draw the dividing line for play/pause
  stroke(150);
  line(width / 2, 0, width / 2, height);
  noStroke();

  // Play or pause the animation based on mouseX position and display the status
  if (mouseX > width / 2) {
    if (!seq.isPlaying()) {
      seq.resume();
    }
    displayStatus("Play", width * 3/4, 30);
  } else {
    if (seq.isPlaying()) {
      seq.pause();
    }
    displayStatus("Pause", width / 4, 30);
  }

  // Draw the dial
  drawDial(width / 2, height / 2, 150, servoValue);
}

// Function to display play/pause status
void displayStatus(String status, float x, float y) {
  fill(0);
  textSize(20);
  textAlign(CENTER, CENTER);
  text(status, x, y);
}

// Other functions remain the same


void drawDial(float x, float y, float diameter, float angle) {
  pushMatrix();
  translate(x, y);
  fill(220);
  ellipse(0, 0, diameter, diameter);
  rotate(radians(angle));
  stroke(0);
  line(0, 0, diameter / 2, 0);
  ellipse(0, 0, diameter/4, diameter/4);
  fill(0);
  textAlign(CENTER, CENTER);
  text((int) angle, 0, 0);
  popMatrix();
}

void mousePressed() {
  // Restart the sequence when the mouse is pressed
  seq.start();
}

void sequenceEnd() {
  // Automatically restart the sequence
  seq.start();
}
