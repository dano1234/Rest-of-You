import java.awt.*;
PFont font;
int counter = 0 ;
String[]  primes = {
  "help", "start", "ocean", "angry", "child", "hint", "stop", "rear", "rope", "shy", "boring", "sad", "moral", "throat", "share", "shoe", "road", "alarm", "female", "coat"
};
String[][] others = {
  {
    "donate", "begin", "water", "mad", "infant", "clue", "end", "back", "string", "quiet", "dull", "unhappy", "ethical", "neck", "give", "boot", "street", "warning", "woman", "jacket"
  }
  , 
  {
    "rotund", "hours", "could", "dug", "levers", "stem", "few", "know", "total", "teeth", "shed", "mineral", "boilers", "rate", "line", "sped", "trying", "lengths", "pages", "habits"
  }
  , 
  {
    "frentd", "guipd", "phewe", "gix", "entupe", "tepr", "rtn", "daot", "spont", "stoow", "sask", "slekies", "whistpy", "easp", "cahe", "kiwn", "clopir", "petsuns", "boaps", "mepalz"
  }
  , 
  {
    "pawet", "", "", "", "jetqen", "", "chp", "fuut", "allit", "", "", "compber", "hedfer", "", "refr", "nomr", "", "greum", "", ""
  }
};
int w = 1280;
int h = 900;

int INSTRUCTIONS1 = 0;
int PRIMING = 1;
int INSTRUCTIONS2 = 2;
int TESTING = 3;
int FINISHED = 4;
int mode = INSTRUCTIONS1;
int wordStartTime;
int[][] testingOrders = {
  {
    0, 1, 2, 3
  }
  , {
    2, 1, 0, 3
  }
  , {
    1, 2, 0, 3
  }
  , {
    1, 0, 2, 3
  }
  , {
    2, 0, 1, 3
  }
  , {
    0, 2, 1, 3
  }
}; //are their others?
int[]  currentOrder;
int placeInOrder = 0;
int[][] results = new int[primes.length][4];
Point primePoint;

boolean showingPrime;

int distanceFromFocus = 150;
int timePerPrimeTotal= 8000;
int timePerPrimeShowing = 60;
int timePerPrimeNotShowing = 500;
int startTimeForThisPrime  = 0;
String maskingWord = "XQFBZRMQWGBX";
int whichPass = -1;
int fontHeight = 24;

Point[]  primeLocs = {
  new Point(w/2- distanceFromFocus, h/2 -distanceFromFocus), 
  new Point(w/2- distanceFromFocus, h/2 +distanceFromFocus), 
  new Point(w/2+ distanceFromFocus, h/2 -distanceFromFocus), 
  new Point(w/2+ distanceFromFocus, h/2 +distanceFromFocus)
};


void setup() {
  size(w, h);

  font = createFont("Helvetica-48", fontHeight);
  textFont(font);
  frameRate(120);
  textAlign(CENTER);
  ellipseMode(CENTER);
  // newPrime();
}

void draw() {
  background(127);
  fill(255);
      ellipse(width/2, height/2, 500, 500);
          ellipse(width/2, height/2, 200, 200);
    ellipse(width/2, height/2, 100, 100);
  if (mode == INSTRUCTIONS1) {
    fill(0,0,0);
    text("INSTRUCTIONS:", width/2, 100-fontHeight*2);
    text("1) Stare at the bullseye in the center of the screen.", width/2, 100-fontHeight);
    text("2) Press the 'E' key if you see flashing text on the left side.", width/2, 100);
    text("3) Press the 'E' key if you see flashing text on the left side.", width/2, 100 +fontHeight);
    text("Press Any Button to begin.", width/2, 100+fontHeight*2);
  }
  if (mode == INSTRUCTIONS2) {
     fill(0,0,0);
    text("INSTRUCTIONS:", width/2, 100-fontHeight*2);
    text("Look at words in bullseye", width/2, 100-fontHeight);
    text("Press Spacebar for real words", width/2, 100);
    text("Prss any other key for fake words", width/2, 100 +fontHeight);
    text("Press Any Button to begin.", width/2, 100+fontHeight*2);
  }
  

  if (mode == PRIMING) {
        fill(0,0,0);
    if ( millis() - wordStartTime >= timePerPrimeTotal) {  //for the word showing or not
      nextWord();
    } 
    else {
      if (showingPrime) {
        if (millis() -startTimeForThisPrime  < timePerPrimeShowing) {
          text(primes[whichPass], primePoint.x + 100, primePoint.y);
        }
        else {
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
    fill(0,0,0);
    text(others[currentOrder[placeInOrder]][whichPass], width/2, height/2);
  }

 
}

void newPrime() {

  println("New Prime");
  whichPass++;
  if (whichPass >= primes.length) {
    mode = FINISHED;
    println(results);
  }
  else {
    showingPrime = false;
    startTimeForThisPrime = millis();
    primePoint = primeLocs[int(random(0, primeLocs.length))];
    wordStartTime = millis();
    currentOrder = testingOrders[int(random(0, testingOrders.length))];
    placeInOrder = 0;
    mode = PRIMING;
  }
}



void nextWord() {
  println(placeInOrder + "New Word" +  currentOrder.length );
  if ((mode == TESTING) && placeInOrder >= currentOrder.length -1 ) {
   mode = INSTRUCTIONS1;
  } 
  else   if (mode == PRIMING) {
    println("From Prime to word");
    mode = TESTING;
    wordStartTime = millis();
  }
  else {
    println("just new word word");
    wordStartTime = millis();
    placeInOrder++;
    if (others[currentOrder[placeInOrder]][whichPass].equals("")) {placeInOrder++; nextWord();}
  }
}

void keyPressed() {
  if (mode == INSTRUCTIONS1) {
   newPrime();
  }
   if (mode == INSTRUCTIONS2) {
   mode = TESTING;
   }
  if (mode == TESTING ) {
    results[whichPass][placeInOrder] = millis()- wordStartTime;
    nextWord();
  }
   if (mode == PRIMING) {
     primePoint = primeLocs[int(random(0, primeLocs.length))];
  }
  //print results
  for (int i = 0; i < results.length; i++) {
    int[] thisWord = results[i];
    print("prime: " + primes[i]  + " " + thisWord.length); 
    for (int j = 0; j < thisWord.length; j++) {
      print( " other:" + others[j][i]);
      print(results[i][j] );
    }
    println("-");
  }
}

