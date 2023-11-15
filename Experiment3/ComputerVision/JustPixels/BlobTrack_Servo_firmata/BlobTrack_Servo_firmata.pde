/*
Blob Tracking to Servo Control
Based ON
// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain
// Code for: https://youtu.be/1scFcY-xMrI

Adapted to send the X value of the first blob to Arduino with Firmata

*/
import processing.serial.*;
import cc.arduino.*;
import processing.video.*;

Arduino arduino; // create an Arduino object to connect to the board
Capture video;

// Servo variables
int servoPin = 2;
int servoAngle_value;

// Used for converting from pixels to angles
int minServoAngle = 0;
int maxServoAngle = 180;

color trackColor; 
float threshold = 25;
float distThreshold = 50;

ArrayList<Blob> blobs = new ArrayList<Blob>();

int cameraIndex = 0; // Change this index to pick a different camera

void setup() {
  size(640, 360);

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
  trackColor = color(255, 0, 0);

  // Firmata setup
  printArray(Arduino.list()); // List COM-ports
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  arduino.pinMode(servoPin, Arduino.SERVO);
}

void captureEvent(Capture video) {
  video.read();
}

void keyPressed() {
  if (key == 'a') {
    distThreshold+=5;
  } else if (key == 'z') {
    distThreshold-=5;
  }
  if (key == 's') {
    threshold+=5;
  } else if (key == 'x') {
    threshold-=5;
  }


  println(distThreshold);
}

void draw() {
  video.loadPixels();
  image(video, 0, 0);

  blobs.clear();


  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      float d = distSq(r1, g1, b1, r2, g2, b2); 

      if (d < threshold*threshold) {

        boolean found = false;
        for (Blob b : blobs) {
          if (b.isNear(x, y)) {
            b.add(x, y);
            found = true;
            break;
          }
        }

        if (!found) {
          Blob b = new Blob(x, y);
          blobs.add(b);
        }
      }
    }
  }

  for (Blob b : blobs) {
    if (b.size() > 500) {
      b.show();
      int blobCenterX = b.getCenterX();
      int blobCenterY = b.getCenterY();
      servoAngle_value = round(map(blobCenterX, 0, width, minServoAngle, maxServoAngle));
      ///send to Arduino
      
      arduino.servoWrite(servoPin, servoAngle_value);
      
      // Draw a bright pink vertical line at the blob center
    stroke(trackColor); 
    line(blobCenterX, 0, blobCenterX, height);
    
    fill(255);
     text("Face X: " + blobCenterX, blobCenterX+20, blobCenterY);
  text("Servo: " + servoAngle_value, blobCenterX+20, blobCenterY+30); 
    }
  }

  textAlign(RIGHT);
  fill(0);
  text("distance threshold: " + distThreshold, width-10, 25);
  text("color threshold: " + threshold, width-10, 50);
}


// Custom distance functions w/ no square root for optimization
float distSq(float x1, float y1, float x2, float y2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
  return d;
}


float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}

void mousePressed() {
  // Save color where the mouse is clicked in trackColor variable
  int loc = mouseX + mouseY*video.width;
  trackColor = video.pixels[loc];
}
