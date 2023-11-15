/*
Expanded face track example using a class to organize data
Shows the x,y position of each face
velocity x,y
and the distance between tracked faces


*/


import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import java.util.Arrays;


Capture video;
OpenCV opencv;
ArrayList<FaceTrack> faceTracks = new ArrayList<FaceTrack>();

void setup() {
  size(640, 480);
  video = new Capture(this, 640, 480);
  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  video.start();
}

void draw() {
  opencv.loadImage(video);

  image(video, 0, 0 );

  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();

  // Update or create FaceTrack objects
  updateFaceTracks(faces);

  // Display each face and lines between them
  for (int i = 0; i < faceTracks.size(); i++) {
    faceTracks.get(i).display();
    for (int j = i + 1; j < faceTracks.size(); j++) {
      float distance = dist(faceTracks.get(i).centerX, faceTracks.get(i).centerY, faceTracks.get(j).centerX, faceTracks.get(j).centerY);
      line(faceTracks.get(i).centerX, faceTracks.get(i).centerY, faceTracks.get(j).centerX, faceTracks.get(j).centerY);
      text("Distance: " + nf(distance, 0, 2), (faceTracks.get(i).centerX + faceTracks.get(j).centerX) / 2, (faceTracks.get(i).centerY + faceTracks.get(j).centerY) / 2);
    }
  }
}

void captureEvent(Capture c) {
  c.read();
}

void updateFaceTracks(Rectangle[] faces) {
  // Update existing tracks or add new ones
  for (Rectangle face : faces) {
    boolean found = false;
    for (FaceTrack track : faceTracks) {
      if (Math.abs(track.centerX - (face.x + face.width / 2.0)) < 50 && Math.abs(track.centerY - (face.y + face.height / 2.0)) < 50) {
        track.update(face);
        found = true;
        break;
      }
    }
    if (!found) {
      faceTracks.add(new FaceTrack(face));
    }
  }

  // Remove old tracks
  faceTracks.removeIf(track -> !Arrays.asList(faces).contains(track.face));
}
