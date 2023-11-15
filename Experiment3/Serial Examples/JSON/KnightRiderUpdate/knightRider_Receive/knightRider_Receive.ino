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
bool led1_value;
String led1_key = "led1";
int led1_Pin = 2;

bool led2_value;
String led2_key = "led2";
int led2_Pin = 3;

bool led3_value;
String led3_key = "led3";
int led3_Pin = 4;

bool led4_value;
String led4_key = "led4";
int led4_Pin = 5;

bool led5_value;
String led5_key = "led5";
int led5_Pin = 6;

bool led6_value;
String led6_key = "led6";
int led6_Pin = 7;

void setup() 
{
  Serial.begin(9600); // Start serial communication at 9600 baud
  //set all the led pins to output
  pinMode(led1_Pin,OUTPUT);
  pinMode(led2_Pin,OUTPUT);
  pinMode(led3_Pin,OUTPUT);
  pinMode(led4_Pin,OUTPUT);
  pinMode(led5_Pin,OUTPUT);
  pinMode(led6_Pin,OUTPUT);

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
      led1_value = procMessage[led1_key];
      led2_value = procMessage[led2_key];
      led3_value = procMessage[led3_key];
      led4_value = procMessage[led4_key];
      led5_value = procMessage[led5_key];
      led6_value = procMessage[led6_key];

    }
  }

  //Apply the values to the actual outputs HERE
  
  digitalWrite(led1_Pin,led1_value);
  digitalWrite(led2_Pin,led2_value);
  digitalWrite(led3_Pin,led3_value);
  digitalWrite(led4_Pin,led4_value);
  digitalWrite(led5_Pin,led5_value);
  digitalWrite(led6_Pin,led6_value);


  //Apply the values to the actual outputs HERE



}