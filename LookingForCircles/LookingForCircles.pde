//Look for Circles in processing
import java.awt.*;

ArrayList positionsInThisStroke = new ArrayList();

Rectangle currentRect = new Rectangle();
String[] circleFeedBack = {
  "Zen Like Circling", "Circular", "Little Flabby", "Square!"
};

int previousX;
int previousY;

void setup() {
  size(320, 240);
}

void draw() {
  if (mousePressed) {
    fill(0, 0, 0);
    ellipse(mouseX-2, mouseY-2, 4, 4);
  }
}

void analyzeStrokes() {

  int totalX = 0;
  int totalY = 0;
  int totalDiff = 0;
  int radius = (currentRect.width + currentRect.height)/4;
  int midx = currentRect.width/2 + currentRect.x;
  int midy = currentRect.height/2 + currentRect.y;
  for (int j =0; j < positionsInThisStroke.size(); j++) {
    Point thisPoint = (Point) positionsInThisStroke.get(j);
    totalX = totalX + thisPoint.x;
    totalY = totalY + thisPoint.y;
    totalDiff = totalDiff + int(abs(radius - dist(thisPoint.x, thisPoint.y, midx, midy)));
  }
  float averageDeviation = float(totalDiff/positionsInThisStroke.size())/radius;
  String feedback = circleFeedBack[int(min(circleFeedBack.length-1, averageDeviation*50))];
  println("Rating:" + averageDeviation + " " + feedback);
}

void mousePressed() {
  positionsInThisStroke = new ArrayList();
  currentRect = new Rectangle();
  currentRect.x = mouseX;
  currentRect.y = mouseY;
}

void mouseDragged() {
  if (dist(previousX, previousY, mouseX, mouseY)> 
  4) {
    currentRect.add(mouseX, mouseY);
    Point here = new Point(mouseX, mouseY);
    positionsInThisStroke.add(here);
    previousX = mouseX;
    previousY = mouseY;
  }
}

void mouseReleased() {
  if (positionsInThisStroke.size() >  0 ) analyzeStrokes();
}
/*
void smoothOutValues(int _whichField, int _howManyStandardDeviationsAcceptable) {
  int total = 0;
  //find the average
  for (int i = 0; i< dates.length; i++ ) {
    Date thisDate = (Date) dates[i];
    int[] thisRecord = (int[]) allRecords.get(thisDate);
    total = total + thisRecord[_whichField];
    // println("Before" + thisRecord[_whichField]);
  }
  //find all the deviations from the average
  int average = total/dates.length;
  int deviations = 0;
  for (int i = 0; i< dates.length; i++ ) {
    Date thisDate = (Date) dates[i];
    int[] thisRecord = (int[]) allRecords.get(thisDate);
    deviations = deviations + Math.abs(thisRecord[_whichField]-average);
  }
  int standardDeviation = deviations/dates.length;
  //kick out things that deviate to far from the average
  for (int i = 0; i< dates.length; i++ ) {
    Date thisDate = (Date) dates[i];
    int[] thisRecord = (int[]) allRecords.get(thisDate);
    int deviation = Math.abs(thisRecord[_whichField]-average);
    if (deviation >
    _howManyStandardDeviationsAcceptable * standardDeviation) {
      thisRecord[_whichField] = average;

      ///BADD
      // allRecords.delete(thisDate);
    }
    // println("After" + thisRecord[_whichField]);
  }
}
*/
