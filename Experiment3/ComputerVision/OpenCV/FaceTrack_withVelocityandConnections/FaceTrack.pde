class FaceTrack {
  Rectangle face;
  float centerX, centerY;
  float velocityX, velocityY;
  float prevCenterX, prevCenterY;

  FaceTrack(Rectangle face) {
    this.face = face;
    centerX = face.x + face.width / 2.0;
    centerY = face.y + face.height / 2.0;
    prevCenterX = centerX;
    prevCenterY = centerY;
  }

  void update(Rectangle newFace) {
    face = newFace;
    prevCenterX = centerX;
    prevCenterY = centerY;
    centerX = face.x + face.width / 2.0;
    centerY = face.y + face.height / 2.0;
    velocityX = centerX - prevCenterX;
    velocityY = centerY - prevCenterY;
  }

  void display() {
    rect(face.x, face.y, face.width, face.height);
    line(prevCenterX, prevCenterY, centerX, centerY); // Line indicating movement
    String info = "X: " + nf(centerX, 0, 2) + "\nY: " + nf(centerY, 0, 2) + "\nVX: " + nf(velocityX, 0, 2) + "\nVY: " + nf(velocityY, 0, 2);
    text(info, centerX, centerY);
  }
}
