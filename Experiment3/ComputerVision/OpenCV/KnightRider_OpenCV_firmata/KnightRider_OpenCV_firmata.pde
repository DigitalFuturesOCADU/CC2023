import cc.arduino.*;
import processing.serial.*;
import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Arduino arduino;
Capture video;
OpenCV opencv;

// LED pin numbers
int[] ledPins = {2, 3, 4, 5, 6, 7};

int cameraIndex = 0; // Change this index to pick a different camera

void setup() {
  size(640, 480); // Size should match the video's dimensions

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

  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);

  // Initialize connection to Arduino
  printArray(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[0], 57600);

  // Set LED pins as outputs
  for (int i = 0; i < ledPins.length; i++) {
    arduino.pinMode(ledPins[i], Arduino.OUTPUT);
  }
}

void draw() {
  opencv.loadImage(video);

  image(video, 0, 0);

  Rectangle[] faces = opencv.detect();

  int sectionWidth = width / 6; // Dynamically calculate the width of each section

  // Turn off all LEDs
  for (int i = 0; i < ledPins.length; i++) {
    arduino.digitalWrite(ledPins[i], Arduino.LOW);
  }
  for (int i = 0; i < ledPins.length; i++) {

    noFill(); // White color for inactive sections
    stroke(0);
    rect(sectionWidth * i, 0, sectionWidth, height); // Adjust height as needed
    }

  // Check if a face is detected and which section it is in
  if (faces.length > 0) {
    int faceX = faces[0].x + faces[0].width / 2; // Center of the first detected face

    for (int i = 0; i < ledPins.length; i++) {
      if (faceX > sectionWidth * i && faceX < sectionWidth * (i + 1)) {
        fill(255, 0, 0,100); // Red color for active section
        arduino.digitalWrite(ledPins[i], Arduino.HIGH);
      
      }
      else {
      noFill(); // White color for inactive sections
    }
    noStroke();
    rect(sectionWidth * i, 0, sectionWidth, height); // Adjust height as needed
    }
    
  }


    
  

  // Draw rectangles around detected faces
  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  for (Rectangle face : faces) {
    rect(face.x, face.y, face.width, face.height);
  }
}

void captureEvent(Capture c) {
  c.read();
}
