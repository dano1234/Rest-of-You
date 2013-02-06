import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.Date;

import processing.serial.Serial;



  public void setup() {
    size(800, 600); // Stage size
    noStroke(); // No border on the next thing drawn
    // Print a list of the serial ports, for debugging purposes to find out what your ports are called:
    String[] dataLines = loadStrings("/Users/dano/Documents/logi.txt");
    //println(dataLines);
    
    int numOfLines = dataLines.length;
    long[] times = new long[numOfLines];
    int[] hearts = new int[numOfLines];
    int[] breaths = new int[numOfLines];

    int smallestHeart = Integer.MAX_VALUE;
    int largestHeart = 0;
    int smallestBreath = Integer.MAX_VALUE;
    int largestBreath = 0;

    for (int i = 0; i < numOfLines; i++) {

      String[] fields = dataLines[i].split(",");
      if (fields.length < 3) continue; // time,breath,heart

      try {

        times[i] = Long.parseLong(fields[0].trim());
        breaths[i] = Integer.parseInt(fields[1].trim());
        hearts[i] = Integer.parseInt(fields[2].trim());

        if (breaths[i] > largestBreath) largestBreath = breaths[i];
        if (breaths[i] < smallestBreath) smallestBreath = breaths[i];
        if (hearts[i] > largestHeart) largestHeart = hearts[i];
        if (hearts[i] < smallestHeart) smallestHeart = hearts[i];
      } 
      catch (NumberFormatException e) {
        System.out.println("Not a Number" + dataLines[i]);
      }
    }
    background(0);
    //fit it to the screen by not showing every value but jumping by an increment
    int increment = numOfLines/width;
    int x = 0;
    for (int i = 0; i < numOfLines; i = i+ increment) {
      float breath = map(breaths[i], smallestBreath, largestBreath, 0, 300);
      float heart = map(hearts[i], smallestHeart, largestHeart, 300, 600);
      fill(255, 0, 0);
      
      ellipse(x, breath, 2, 2);
      fill(0, 255, 0);
      ellipse(x, heart, 2, 2);
      x++;
      // System.out.println(heart + " elllipse " + breath);
    }
  }

  public void draw() {
  }

