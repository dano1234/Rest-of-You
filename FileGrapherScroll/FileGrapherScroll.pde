import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.Date;

import processing.serial.Serial;



  boolean timeStamped = true;
  long[] times;
  DataField[] fields;
  boolean[] badData;
  String delimiter = ",";
  String filename = "/Users/dano/Documents/logi.txt";
  PFont font;

  public void setup() {
    
    
    size(1024, 600); // Stage size
    noStroke(); // No border on the next thing drawn
    font = createFont("ArialMT-12.vlw", 24);
    int numValidReadings = 0;
    // Print a list of the serial ports, for debugging purposes to find out what your ports are called:
    String[] dataLines = loadStrings(filename);
    int numOfLines = dataLines.length;
    println("Attempting to load " + numOfLines + " lines.");
    String[] fieldNames = dataLines[0].split(delimiter);
    int numberOfFields = fieldNames.length;
    badData = new boolean[numOfLines]; 
    //make a list of times
    if (timeStamped) {
      numberOfFields--; // nock one field off if the first one is a timestamp
      times = new long[numOfLines];
    }
    //make a field object for each field (except time)
    int[] colors = new int[] { 0xffff0000, 0xff00ff00, 0xff0000ff, 0xffffff00, 0xffff00ff, 0xff00ffff };
    fields = new DataField[numberOfFields];
    for (int i = 0; i < numberOfFields; i++) {
      String fieldName = fieldNames[i];
      if (timeStamped) fieldName = fieldNames[i + 1];
      fields[i] = new DataField(numOfLines, 7, fieldName, colors[i]);
    }

    // get the data
    for (int lineNumber = 1; lineNumber < numOfLines; lineNumber++) {
      String[] fieldValues = dataLines[lineNumber].split(delimiter);
      if (fieldValues.length != fieldNames.length) {
        badData[lineNumber] = true;
        System.out.println("Bad number of fields " + lineNumber + " " + dataLines[lineNumber]);
        continue; // not all field present in this line
      }
      
      for (int fieldNumber = 0; fieldNumber < fieldValues.length; fieldNumber++) {
        int thisValue = 0;

        try {
          if (timeStamped && fieldNumber == 0) {
            //just record the time into the time array
            times[lineNumber] = Long.parseLong(fieldValues[0].trim());
          } else {
            //record the value into the object for that field.
            thisValue = Integer.parseInt(fieldValues[fieldNumber].trim());
            int whichField = fieldNumber;
            if (timeStamped)  whichField--;
            fields[whichField].setValue(lineNumber, thisValue);
            fields[whichField].checkForPeak(lineNumber, thisValue);
          }
        } catch (NumberFormatException e) {
          System.out.println("Couldn't parse line " + lineNumber + " " + dataLines[lineNumber]);
          badData[lineNumber] = true;
          continue;
        } catch (Exception e) {
          badData[lineNumber] = true;
          System.out.println("Something bad " + lineNumber + " " + dataLines[lineNumber] + e);
          continue;
        }
      }
      numValidReadings++; // valid readings
    }

    //show stats
    println("Data has " + numberOfFields + " fields.");
    println("Read in " + numValidReadings + " valid readings");
    for (int i = 0; i < fields.length; i++) {
      DataField thisField = fields[i];
      println("Extreme " + thisField.smallestValueEver + " to " + thisField.smallestValueEver);
    }

    drawIt(0);
  }

  public void draw() {

  }

  public void drawIt(int _where) {
    background(255);
    float percentageAcrossScreen = (float) _where / width;
    int amountThatWontFitOnScreen = max(0, times.length - width);
    int offset = (int) (amountThatWontFitOnScreen * percentageAcrossScreen);
    int end = min(width + offset, times.length-1);

    for (int reading = offset; reading <= end; reading++) {
      if(badData[reading]) continue;
      int xpos = reading - offset;
      for (int fieldNumber = 0; fieldNumber < fields.length; fieldNumber++) {
        DataField thisField = fields[fieldNumber];
        float ypos = map(thisField.getValue(reading), thisField.smallestValueEver, thisField.biggestValueEver, 0, 300);
        fill(thisField.getColor());
        // fill(255-fieldNumber*50,0,fieldNumber*50);
        ellipse(xpos, ypos, 1, 1);
        int peak = thisField.isAPeak(reading);
        if (peak == 1) {
          fill(0, 0, 0);
          ellipse(xpos-8, ypos-8, 5, 5);
        } else if (peak == -1) {
          fill(0, 0, 0);
          ellipse(xpos-8, ypos-8, 5, 5);
        }

      }

      // show where we are in the scrolling at the botom
      fill(255, 0, 0);
      textFont(font, 12);
      if (reading == offset) {

        if (timeStamped) {
          Date d = new Date(times[reading]);
          text(d.toString(), 0, height - 30);
          text("Millis: " + times[reading], 0, height - 10);
        } else {
          text("First Shown" + offset, 0, height - 30);

        }
      } else if (reading == end) {
        if (timeStamped) {
          Date d = new Date(times[reading]);

          text(d.toString(), width - textWidth(d.toString()), height - 30);
          text("Millis: " + times[reading], width - textWidth("Millis: " + times[reading]), height - 10);
        } else {
          text("Last Shown " + end, width - textWidth("Last Shown " + end), height - 30);

        }
      }

      // color key field names at the top
      float textpos = 20;
      for (int i = 0; i < fields.length; i++) {
        DataField thisField = fields[i];
        fill(thisField.myColor);
        textFont(font, 32);
        text(thisField.fieldName+ "      ", textpos, 40);
        textpos = textpos + textWidth(thisField.fieldName + "      ");
      }

    }
  }

  public void mousePressed() {
    drawIt(mouseX);
  }




