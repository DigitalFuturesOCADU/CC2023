/*
Basic Starter template for sending data from Processing

1. Update this line of code to point to your Serial port
   arduinoPort = new Serial(this, Serial.list()[0], 9600);

2. Create variables that will hold each of the values you need to send
-Make sure that the variable type matches what you will want on the Arduino Side
--Servos                                                    int variable
--Fading LEDs (analogWrite())                               int variable
--Blinking LEDs or turning ON/Off Relay  (digitalWrite)     boolean variable
--NeoPixels                                                 Use NeoPixelRead 

3. Each Variable holding a value should have a corresponding String variable that holds
   the name of it property *key*

4. When adding each value to the JSONObject variable BE SURE to:
-Use the correct "set" method for the object https://processing.org/reference/JSONObject.html
--Integers   ardMessage.setInt(*keyName String variable*, *integer variable*)
--Booleans   ardMessage.setBoolean(*keyName String variable*, *boolean variable*)


*/


import processing.serial.*;
Serial arduinoPort;  // Create object from Serial class

//Create your variables / keys to send here
// Declare boolean variables for each LED
boolean led1_value;
String led1_key = "led1";
boolean led2_value;
String led2_key = "led2";
boolean led3_value;
String led3_key = "led3";
boolean led4_value;
String led4_key = "led4";
boolean led5_value;
String led5_key = "led5";
boolean led6_value;
String led6_key = "led6";


//Create your variables / keys to send here

void setup() 
{
   size(1000, 500);  // Window size
  //printArray(Serial.list());  // List COM-ports
  // Open the port that the Arduino is connected to (change this to match your setup)
  arduinoPort = new Serial(this, Serial.list()[0], 9600);

}

void draw() 
{
  //set fill and stroke to black
  
  background(255);
  
   // Reset all LEDs to false
  led1_value = false;
  led2_value = false;
  led3_value = false;
  led4_value = false;
  led5_value = false;
  led6_value = false;

  int sectionWidth = width / 6; // Dynamically calculate the width of each section

  // Determine which section the mouse is in and set the corresponding LED to true
  if (mouseX < sectionWidth) {
    led1_value = true;
  } else if (mouseX < sectionWidth * 2) {
    led2_value = true;
  } else if (mouseX < sectionWidth * 3) {
    led3_value = true;
  } else if (mouseX < sectionWidth * 4) {
    led4_value = true;
  } else if (mouseX < sectionWidth * 5) {
    led5_value = true;
  } else {
    led6_value = true;
  }

  // Draw rectangles and set color based on LED state
  for (int i = 0; i < 6; i++) {
    if (mouseX > sectionWidth * i && mouseX < sectionWidth * (i + 1)) {
      fill(255, 0, 0); // Red color for active section
    } else {
      fill(255); // White color for inactive sections
    }
    rect(sectionWidth * i, 0, sectionWidth, height);
  }
  

 ///*****This is the message to Arduino Part 
  //create the JSON Object and add the servo value
  JSONObject ardMessage = new JSONObject();
  //add the values to the JSON Object HERE
  ardMessage.setBoolean(led1_key,led1_value);
  ardMessage.setBoolean(led2_key,led2_value);
  ardMessage.setBoolean(led3_key,led3_value);
  ardMessage.setBoolean(led4_key,led4_value);
  ardMessage.setBoolean(led5_key,led5_value);
  ardMessage.setBoolean(led6_key,led6_value);
  
  //Serialize the object and write it to the Port
  arduinoPort.write(ardMessage.toString());
  
  //uncomment to see the message
  //println(ardMessage.toString());
  
 ///*****This is the message to Arduino Part   
  

}
