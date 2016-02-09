import java.awt.*;
PFont font;
int counter = 0 ;
String words[] =
  {
  "help donate rotund frentd pawet", 
  "start begin hours guipd --", 
  "ocean water could phewe --", 
  "angry mad dug gix --"
  /*, 
  "child infant levers entupe jetqen", 
  "hint clue stem tepr --", 
  "stop end few rtn chp", 
  "rear back know daot fuut", 
  "rope string total spont allit", 
  "shy quiet teeth stoow --", 
  "boring dull shed sask --", 
  "sad unhappy mineral slekies compber", 
  "moral ethical boilers whistpy hedfer", 
  "throat neck rate easp --", 
  "share give line cahe refr", 
  "shoe boot sped kiwn nomr", 
  "road street trying clopir --", 
  "alarm warning lengths petsuns greum", 
  "female woman pages boaps --", 
  "coat jacket habits mepalz --"
  */
};

String currentPrimeWord = "";




int INSTRUCTIONS1 = 0;
int PRIMING = 1;
int INSTRUCTIONS2 = 2;
int TESTING = 3;
int FINISHED = 4;
int mode = INSTRUCTIONS1;
int wordStartTime;
int[][] testingOrders = {{ 1, 2, 3, 4}, {1, 2, 1, 4}, { 2, 3, 1, 4}, { 2, 1, 3, 4}, {3, 1, 2, 4}, {1, 3, 2, 4}}; //are their others?
int[]  currentOrder;
int placeInOrder = 0;
String[][] results = new String[words.length][4];
String[] currentWords ;
String currentWord;
Point primePoint;

boolean showingPrime;

int distanceFromCenter = 150;
int timePerPrimeTotal= 8000;
int timePerPrimeShowing = 60;
int timePerPrimeNotShowing = 500;
int startTimeForThisPrime  = 0;
String maskingWord = "XQFBZRMQWGBX";
int whichPrime = -1;
int fontHeight = 24;

Point[]  primeLocs = new Point[4] ;


void setup() {
  size(displayWidth, displayHeight);

  font = createFont("Helvetica-48", fontHeight);
  textFont(font);
  frameRate(120);
  textAlign(CENTER);
  ellipseMode(CENTER);
  // showPrime();
  primeLocs[0] = new Point(width/2- distanceFromCenter, height/2 -distanceFromCenter);
  primeLocs[1] = new Point(width/2- distanceFromCenter, height/2 +distanceFromCenter); 
  primeLocs[2] =  new Point(width/2+ distanceFromCenter, height/2 -distanceFromCenter); 
  primeLocs[3] =  new Point(width/2+ distanceFromCenter, height/2 +distanceFromCenter);
}

void draw() {
  background(127);
  fill(255);
  ellipse(width/2, height/2, 500, 500);
  ellipse(width/2, height/2, 200, 200);
  ellipse(width/2, height/2, 100, 100);
  if (mode == INSTRUCTIONS1) {
    fill(0, 0, 0);
    text("INSTRUCTIONS:", width/2, 100-fontHeight*2);
    text("1) Stare at the bullseye in the center of the screen.", width/2, 100-fontHeight);
    text("2) Press the 'e' key if you see flashing text on the left side.", width/2, 100);
    text("3) Press the 'i' key if you see flashing text on the right side.", width/2, 100 +fontHeight);
    text("Press Any Button to begin.", width/2, 100+fontHeight*2);
  }
  if (mode == INSTRUCTIONS2) {
    fill(0, 0, 0);
    text("INSTRUCTIONS:", width/2, 100-fontHeight*2);
    text("Look at words in bullseye", width/2, 100-fontHeight);
    text("Press Spacebar for real words", width/2, 100);
    text("Prss any other key for fake words", width/2, 100 +fontHeight);
    text("Press Any Button to begin.", width/2, 100+fontHeight*2);
  }


  if (mode == PRIMING) {
    fill(0, 0, 0);
    if ( millis() - wordStartTime >= timePerPrimeTotal) {  //for the word showing or not
      mode = INSTRUCTIONS2;
    } else {
      if (showingPrime) {
        if (millis() -startTimeForThisPrime  < timePerPrimeShowing) {
          text(currentPrimeWord, primePoint.x + 100, primePoint.y);
        } else {
          showingPrime = false;
          startTimeForThisPrime = millis();
        }
      }
      if (!showingPrime) {
        text(maskingWord, primePoint.x, primePoint.y);
        if (millis() -startTimeForThisPrime  > timePerPrimeNotShowing) {
          showingPrime = true;
          startTimeForThisPrime = millis();
        }
      }
    }
  }
  if (mode == TESTING) {
    fill(0, 0, 0);
    text(currentWord, width/2, height/2);
  }
  if (mode == FINISHED) {
    fill(0, 0, 0);
    text("FINISHED", width/2, height/2);
  }
  
}

void newPrime() {

  //println("New Prime");
  whichPrime++;
  if (whichPrime >= words.length) {
    mode = FINISHED;
    //println(results);
  } else {
    showingPrime = false;
    startTimeForThisPrime = millis();
    primePoint = primeLocs[int(random(0, primeLocs.length))];
    wordStartTime = millis();
    currentWords = words[whichPrime].split(" ");
    currentPrimeWord = currentWords[0];
    currentOrder = testingOrders[int(random(0, testingOrders.length))];
    placeInOrder = 0;
    mode = PRIMING;
    printResults();
  }
}



void nextTest() {
  if (mode == TESTING) {
    //if last word was testing rather than instructions
    results[whichPrime][placeInOrder] = currentWord + ":" + (millis()-wordStartTime);
  }
  mode = TESTING;
  // println(placeInOrder + "New Word" +  currentOrder.length );
  if (placeInOrder >= currentOrder.length-1 ) {
    mode = INSTRUCTIONS1;
  } else {
    // println("just new word word");
    placeInOrder++;
    currentWord = currentWords[currentOrder[placeInOrder]];
   // print(placeInOrder, currentOrder[placeInOrder], currentWord);
    wordStartTime = millis();
  }
}

void keyPressed() {
  if (mode == INSTRUCTIONS1) {
    //printResults();
    newPrime();
  } else if (mode == TESTING ) {
    // results[whichPrime][placeInOrder] = millis()- wordStartTime;
    nextTest();
  } else if (mode == INSTRUCTIONS2) {
    nextTest();
  } else if (mode == PRIMING) {
    placeInOrder = 0;  // at prime
    primePoint = primeLocs[int(random(0, primeLocs.length))];
  }
}

void printResults() {
  //print results
  for (int i = 0; i < results.length; i++) {
    String[] thisRow = results[i];
    if (results[i][2] == null) continue;
    println("prime: " + words[i]  ); 
    for (int j = 0; j < thisRow.length; j++) {
      print(results[i][j]  + "  "  );
    }
    //println("-");
  }
}
