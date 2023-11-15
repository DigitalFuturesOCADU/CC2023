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

int servoAngle_value;
String servoAngle_key = "servoVal";

//used for converting from pixels to angles
int minServoAngle = 0;
int maxServoAngle = 180;

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
  fill(0);
  stroke(0);
  background(255);
  
   //show which port is connected
  text("Port: "+Serial.list()[0],20,20);
  //get mouseX and convert it to 0 - 180 as an integer
  servoAngle_value = round(map(mouseX,0,width,minServoAngle,maxServoAngle));

  //draw a vertical line and the mouseX location
  //show the mouse value and the servoValue
  line(mouseX,0,mouseX,height);
  text("mouse: "+mouseX,mouseX+10,height/2);
  text("servo: "+servoAngle_value,mouseX+10,height/2+15);
  

 ///*****This is the message to Arduino Part 
  //create the JSON Object and add the servo value
  JSONObject ardMessage = new JSONObject();
  //add the values to the JSON Object HERE
  ardMessage.setInt(servoAngle_key,servoAngle_value);
  
  
  
  //Serialize the object and write it to the Port
  arduinoPort.write(ardMessage.toString());
  
  //uncomment to see the message
  //println(ardMessage.toString());
  
 ///*****This is the message to Arduino Part   
  

}
