/*Mouse Control of LEDS using firmata
-Uses StandardFirmata
-LED pins are saved in an array
-pinMode is set to output in setup() using a for loop
    for (int i = 0; i < ledPins.length; i++) {
    arduino.pinMode(ledPins[i], Arduino.OUTPUT);
  }
  
-A for loop is also used to write their values in draw
-Adjust line 27 to match your Serial port


*/

import cc.arduino.*;
import processing.serial.*;

Arduino arduino;

// LED pin numbers
int[] ledPins = {2, 3, 4, 5, 6, 7};

void setup() 
{
  size(1000, 500);  // Window size
  printArray(Arduino.list());  // List COM-ports

  // Initialize connection to Arduino
  arduino = new Arduino(this, Arduino.list()[0], 57600);

  // Set LED pins as outputs
  for (int i = 0; i < ledPins.length; i++) {
    arduino.pinMode(ledPins[i], Arduino.OUTPUT);
  }
}

void draw() 
{
  background(255);

  int sectionWidth = width / 6; // Dynamically calculate the width of each section

  // Turn off all LEDs
  for (int i = 0; i < ledPins.length; i++) {
    arduino.digitalWrite(ledPins[i], Arduino.LOW);
  }

  // Check which section the mouse is in and turn on the corresponding LED
  for (int i = 0; i < ledPins.length; i++) {
    if (mouseX > sectionWidth * i && mouseX < sectionWidth * (i + 1)) {
      arduino.digitalWrite(ledPins[i], Arduino.HIGH);
      fill(255, 0, 0); // Red color for active section
    } else {
      fill(255); // White color for inactive sections
    }
    rect(sectionWidth * i, 0, sectionWidth, height);
  }
}
