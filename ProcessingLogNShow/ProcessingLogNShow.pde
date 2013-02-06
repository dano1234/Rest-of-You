
import java.io.FileNotFoundException;
import java.io.FileOutputStream;

import processing.core.PApplet;
import processing.serial.Serial;


Serial port; // The serial port
int xpos;
int expectedNumberOfSensors = 6;
int nowShowing =0;

FileOutputStream file;

int screenPos;
int lastx;
int lasty;
int mid;

public void setup() {
  size(displayWidth*3/4, 600); // Stage size
  mid = height/2;
  stroke(255);
  // Print a list of the serial ports, for debugging purposes to find out what your ports are called:
  println(Serial.list());
  //
  port = new Serial(this, Serial.list()[0], 9600); //you can pull the name out of the list
  port.clear();
  //  port = new Serial(this, "/dev/tty.usbserial-A300119a", 9600); // or you can just specify it
  //port.write(65); // Send a capital A in case the microcontroller is waiting to hear from you

  try {
    file = new FileOutputStream("/Users/dano/Documents/logi.txt", true);//true means append to the file
  }
  catch (FileNotFoundException donnaKaran) {
    donnaKaran.printStackTrace();
  }

  background(0);
}

public void draw() {
}

public void serialEvent(Serial port) {
  String input = port.readStringUntil(10); // make sure you return (Ascii 13) at the end of your transmission
  if (input != null) {
    println("raw Input: " + input);

    long now = System.currentTimeMillis();
    String thisReading = now + "," + input;  //prepend a timestamp to the reading
    try {
      file.write(thisReading.getBytes("UTF8")); // send the input to a file
    }
    catch (Exception e) {
      println("Error: Can’t write file!" );
    }

    //okay lets draw it too.
    String[] allInput = input.split(",");
    String thisInput = allInput[nowShowing];
    thisInput = thisInput.trim(); //precaution in case there is an extra 10 character attached

    int inputAsInt = Integer.parseInt( thisInput); //turn the string back into a number

    if (screenPos == width) {  //did you get to the end of screen?
      screenPos = 0;
      background(0);
      lastx = 0;
      lasty =0;
    }
    int y = inputAsInt/2; //mid - inputAsInt/2;
    stroke(255);

    line(lastx, lasty, screenPos, y);
    lastx = screenPos;
    lasty =y;
    screenPos++;
  }
}

public void keyPressed() {
  //pick a sensor
  if (key == '-') {
    nowShowing = max(0, nowShowing -1);
  }
  else if (key == '=') {
    nowShowing = min(expectedNumberOfSensors-1, nowShowing +1);
  }
  println("Now Showing " + nowShowing);
}

