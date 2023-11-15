/*
Convert pixel differnce to LED brightness
based on
Learning Processing // Example 16-14: Overall motion
http://learningprocessing.com/examples/chp16/example-16-14-MotionSensor



*/
import processing.serial.*;
import cc.arduino.*;
import processing.video.*;

Arduino arduino; // Create an Arduino object to connect to the board
Capture video;   // Variable for capture device
PImage prevFrame; // Previous Frame

int ledPin = 3; // LED connected to pin 3

// Motion detection variables
float threshold = 50;
float avgMotion; // Global variable for average motion

// Calibration variables
float minMotion = 10;
float maxMotion = 100;  // Maximum motion value expected
int minBrightness = 0;  // Minimum LED brightness
int maxBrightness = 255; // Maximum LED brightness

int cameraIndex = 0; // Change this index to pick a different camera

void setup() {
  size(640,480);

  // Camera selection logic
  String[] cameras = Capture.list();
  printArray(cameras);
  if (cameras.length > 0 && cameraIndex < cameras.length) {
    video = new Capture(this, cameras[cameraIndex]);
  } else {
    println("Camera index is out of bounds.");
    exit();
  }
  video.start();
  
  prevFrame = createImage(video.width, video.height, RGB);

  // Firmata setup
  printArray(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  arduino.pinMode(ledPin, Arduino.OUTPUT);
}

void captureEvent(Capture video) {
  prevFrame.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height);
  prevFrame.updatePixels();
  video.read();
}

void draw() {
  background(0);
  image(video, 0, 0);

  video.loadPixels();
  prevFrame.loadPixels();

  float totalMotion = 0;

  for (int i = 0; i < video.pixels.length; i++) {
    color current = video.pixels[i];
    color previous = prevFrame.pixels[i];

    float diff = dist(red(current), green(current), blue(current), red(previous), green(previous), blue(previous));
    totalMotion += diff;
  }

  avgMotion = totalMotion / video.pixels.length;

  // Map avgMotion to LED brightness
  int ledBrightness = int(map(avgMotion, minMotion, maxMotion, minBrightness, maxBrightness));
  ledBrightness = constrain(ledBrightness, minBrightness, maxBrightness);

  // Send the LED brightness value to the Arduino
  arduino.analogWrite(ledPin, ledBrightness);

  // Visual representation of motion
  noStroke();
  fill(0);
  float r = avgMotion * 2;
  ellipse(width/2, height/2, r, r);
}
