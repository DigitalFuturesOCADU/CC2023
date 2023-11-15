/*
Calculates the average color of all pixels in the feed and the average brightness
Adjust the webcam it uses by changing the line
cam = new Capture(this, cameras[0]);

Connects to brightness of an LEd connected to pin3 using firmata and the StandardFirmata file


*/

import processing.video.*;
import cc.arduino.*;
import org.firmata.*;
import processing.serial.*;

Capture cam;

float avgR;
float avgG;
float avgB;

float avgBrightness;

float minVidBrightness = 20;
float maxVidBrightness = 255;

float minLEDbrightness = 0;
float maxLEDbrightness = 255;

boolean showVideo = true;
Arduino arduino;
int ledPin = 3; // LED connected to pin 3

int cameraIndex = 0; // Change this index to pick a different camera

void setup() {
  size(640, 480);
  
  // Camera selection logic
  String[] cameras = Capture.list();
  printArray(cameras);
  if (cameras.length > 0 && cameraIndex < cameras.length) {
    cam = new Capture(this, cameras[cameraIndex]);
    cam.start();
  } else {
    println("Camera index is out of bounds.");
    exit();
  }

  // Initialize Arduino communication
  printArray(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[0], 57600); // Adjust the index [0] if necessary
  arduino.pinMode(ledPin, Arduino.OUTPUT);
}

void draw() {
  background(255);
  
  if (cam.available() == true) {
    cam.read();
  }
  
  calculateAverageColor();
  
  // Draw the average color rectangle
  fill(avgR, avgG, avgB);
  rect(0, 0, width / 2, height);
  fill(0); // Black text color
  text("Average Color\nR: " + nf(avgR, 1, 2) + "\nG: " + nf(avgG, 1, 2) + "\nB: " + nf(avgB, 1, 2), 10, height/2);
  
  // Draw the average brightness rectangle
  fill(avgBrightness);
  rect(width / 2, 0, width / 2, height);
  fill(255); // White text color for contrast
  text("Average Brightness\nValue: " + nf(avgBrightness, 1, 2), width / 2 + 10, height/2);
  
  if(showVideo){
    image(cam, 10, 10, cam.width / 4, cam.height / 4);
  }

  // Update LED brightness
  int brightnessValue = int(map(avgBrightness, minVidBrightness, maxVidBrightness, minLEDbrightness, maxLEDbrightness)); // Map avgBrightness to 0-255
  arduino.analogWrite(ledPin, brightnessValue);
}

void calculateAverageColor() {
  avgR = avgG = avgB = avgBrightness = 0;
  cam.loadPixels();
  for (int i = 0; i < cam.pixels.length; i++) {
    color c = cam.pixels[i];
    avgR += red(c);
    avgG += green(c);
    avgB += blue(c);
    avgBrightness += brightness(c);
  }
  avgR /= cam.pixels.length;
  avgG /= cam.pixels.length;
  avgB /= cam.pixels.length;
  avgBrightness /= cam.pixels.length;
}

void mousePressed() {
  showVideo = !showVideo;
}
