//import libraries
import processing.serial.*;
import cc.arduino.*;

//initialize the Arduino class and name it 'arduino'
Arduino arduino;

//define the analog input vals
String[] pins = { "KB CV", "TRIG", "VCO", "EG", "LFO", "VCF"};

//initialize the output values from each val
int val0;
int val1;
int val2;
int val3;
int val4;
int val5;
int[] vals = new int[6];

void setup() {
  arduino = new Arduino(this, Arduino.list()[1], 57600);
  size(400, 400);
  
  textSize(32);
  textAlign(LEFT, TOP);
  fill(0);
}

void draw() {
  background(255);
  for (int i = 0; i < pins.length; i++) {
    vals[i] = arduino.analogRead(i);
    text(pins[i] + ": " + vals[i], 50, i * 60);
    //println(vals[i]);
  }
}