/*
Control Servo Rotation with face tracking
Maps the X coordinate of the center of a face to the rotation of a servo using 
OpenCV and firmata


*/


import processing.serial.*;
import cc.arduino.*;
import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Arduino arduino; // create an Arduino object to connect to the board
Capture video;
OpenCV opencv;

// Servo variables
int servoPin = 2;
int servoAngle_value;
int faceX; // X-coordinate of the face center
int faceY; // Y-coordinate of the face center
// Used for converting from pixels to angles
int minServoAngle = 0;
int maxServoAngle = 180;

int cameraIndex = 0; // default camera index, change this to select different camera

void setup() 
{
  size(640, 480);  // Window size for video capture
  printArray(Arduino.list());  // List COM-ports

  // List available cameras
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(i + ": " + cameras[i]);
    }
  }

  // Open the port that the Arduino is connected to (change this to match your setup)
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  
  // Set servo pin as output
  arduino.pinMode(servoPin, Arduino.SERVO);

  // Setup for OpenCV and video capture
  video = new Capture(this, cameras[cameraIndex]);
  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  video.start();
}

void draw() 
{
  opencv.loadImage(video);
  image(video, 0, 0 );
  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();

  if (faces.length > 0) {
    // Assuming only one face is present, get the x-coordinate of the center of the first face
    faceX = faces[0].x + faces[0].width / 2;
    faceY = faces[0].y + faces[0].height / 2;
    rect(faces[0].x, faces[0].y, faces[0].width, faces[0].height);

    // Convert faceX to a servo angle
    servoAngle_value = round(map(faceX, 0, width, minServoAngle, maxServoAngle));
    arduino.servoWrite(servoPin, servoAngle_value);

    // Draw a bright pink vertical line at the face center
    stroke(255, 20, 147); // Bright pink color
    line(faceX, 0, faceX, height);
  }

  // Display face position and servo angle
  text("Face X: " + faceX, faceX+20, faceY);
  text("Servo: " + servoAngle_value, faceX+20, faceY+30);
}

void captureEvent(Capture c) {
  c.read();
}
