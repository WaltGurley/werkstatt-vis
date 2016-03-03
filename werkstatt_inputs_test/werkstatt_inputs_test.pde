//import libraries
import processing.serial.*;
import cc.arduino.*;

//initialize the Arduino class and name it 'arduino'
Arduino arduino;

//define the analog input vals
String[] pins = { "KB CV", "TRIG", "VCO", "EG", "LFO", "VCF"};

//initialize the output values from each val
int[] vals = new int[pins.length];

//initialize smooth value array
Smooth[] smoother;

void setup() {
  arduino = new Arduino(this, Arduino.list()[1], 57600);
  size(600, 400);

  textSize(32);
  textAlign(LEFT, TOP);
  fill(0);
  
  smoother = new Smooth[pins.length];
  for (int i = 0; i < pins.length; i++) {
    smoother[i] = new Smooth(20, i);
  }
}

void draw() {
  background(255);
  for (int i = 0; i < pins.length; i++) {
    vals[i] = arduino.analogRead(i);
    text(pins[i] + ": " + vals[i], 10, i * 60);
    text(pins[i] + ": " + smoother[i].smooth(arduino.analogRead(i)), width / 2 + 10, i * 60);
    println();
  }
}

//Class to create create smoothed value from input of set number of values
class Smooth {
  int smoothLength;
  int sumReadings = 0;
  int[] readingCount;
  int readIndex = 0;
  int readVal;
  int pin;

  Smooth(int smoothingLength, int pinNumber) {
    smoothLength = smoothingLength;
    readingCount = new int[smoothLength];
    pin = pinNumber; 
    for (int firstReading = 0; firstReading < smoothLength; firstReading++) {
      readingCount[firstReading] = 0;
    }
    println(readingCount);
  }

  int smooth(int valueFromPin) {
    sumReadings = sumReadings - readingCount[readIndex];
    readingCount[readIndex] = valueFromPin;
    sumReadings = sumReadings + readingCount[readIndex];
    readIndex = readIndex + 1;

    if (readIndex >= smoothLength) {
      readIndex = 0;
    }

    valueFromPin = sumReadings / smoothLength;
    return valueFromPin;
  }
}