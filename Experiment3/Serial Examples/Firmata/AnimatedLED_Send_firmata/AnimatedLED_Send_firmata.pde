/*
Animates the brightness of the LED using Ani and Firmata

mouse position controls play/pause
*/


import de.looksgood.ani.*;
import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
AniSequence seq;
int ledPin = 3;
float ledBrightness;

void setup() {
  size(512, 512);
  smooth();
  noStroke();
  textAlign(CENTER);
  background(255);

  // Initialize Arduino and set the LED pin
  printArray(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  arduino.pinMode(ledPin, Arduino.OUTPUT);

  // Initialize Ani library and create an animation sequence for LED fading
  Ani.init(this);
  seq = new AniSequence(this);
  seq.beginSequence();
  
  // Define animation steps
  seq.add(Ani.to(this, 1, "ledBrightness", 100));
  seq.add(Ani.to(this, 0.5, "ledBrightness", 100));
  seq.add(Ani.to(this, 0.2, "ledBrightness", 255));
  seq.add(Ani.to(this, 0.5, "ledBrightness", 255));
  seq.add(Ani.to(this, 1, "ledBrightness", 0, Ani.LINEAR, "onEnd:sequenceEnd"));
  
  seq.endSequence();
  seq.start();
}

void draw() {
  background(255);
  
  // Draw the play/pause threshold line
  stroke(0);
  strokeWeight(1);
  line(width / 2, 0, width / 2, height);

  //Draw a white ellipse over the line to hide it
  fill(255);
  ellipse(width / 2, height / 2, 150, 150);
  // Draw the fading circle with the current brightness
  fill(255, 0, 0, ledBrightness);
  ellipse(width / 2, height / 2, 150, 150);

  // Draw the brightness value inside the ellipse
  fill(0);
  text(round(ledBrightness), width / 2, height / 2);



  // Determine and display the animation state (Play/Pause)
  //this is a condensed way of writing an If statement
  String stateText = seq.isPlaying() ? "Play" : "Pause";
  text(stateText, 30, 30);

  // Control the animation based on mouseX position
  if (mouseX > width / 2 && !seq.isPlaying()) {
    seq.resume();
  } else if (mouseX <= width / 2 && seq.isPlaying()) {
    seq.pause();
  }
  
  // Update the LED brightness
  arduino.analogWrite(ledPin, round(ledBrightness));  
  
  
}

void mousePressed() {
  // Restart the sequence when the mouse is pressed
  seq.start();
}

void sequenceEnd() {
  // Automatically restart the sequence
  seq.start();
}
