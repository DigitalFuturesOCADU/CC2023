/*
Basic Starter template for RECEIVING data from Processing


1. Create variable that will hold each value from Processing
**Be sure the variable type matches the type sent from processing
int -> int
boolean -> bool                                              

2. Each Variable holding a value should have a corresponding String variable that holds
   the name of it property *key*

3. Create an int variable for the Pin number associated with the value

4. If it is a special datatype like Servo create it as well

*/


#include <Servo.h>
#include <ArduinoJson.h>

// Variables to store the mouse data
int servoAngle_value;
String servoAngle_key = "servoVal";
int servoAngle_Pin = 2;
Servo mouseServo;

void setup() 
{
  Serial.begin(9600); // Start serial communication at 9600 baud

  //attach the servo to the pin
  mouseServo.attach(servoAngle_Pin);
}

void loop() 
{
  // Check if there's any data available on the serial port
  if (Serial.available()) 
  {
    StaticJsonDocument<200> procMessage; // Adjust size according to your JSON object

    // Deserialize the JSON from the Serial stream
    DeserializationError error = deserializeJson(procMessage, Serial);

    // Check for errors in deserialization
    if (!error) 
    {
      ///Add your code here to read the value from the procMessage object into your variable
      //for each it will follow the template
      //*nameOfArduinoVariable* = procMessage[*nameOfValueKeyForThatVariable*];
      servoAngle_value = procMessage[servoAngle_key];

    }
  }

  //Apply the values to the actual outputs HERE
  //write it to the servo
  mouseServo.write(servoAngle_value);


  //Apply the values to the actual outputs HERE



}