var maskingWord = "XQFBZRMQWGBX";
var words = [
  {"prime":"Tall", "option1":"Woman", "option2":"Man"},
  {"prime":"Small", "option1":"White", "option2":"Black"},
  {"prime":"Irish", "option1":"Dumb", "option2":"Smart"},
  {"prime":"Old", "option1":"Fast", "option2":"Slow"}
  ]
var timePerPrimeShowing = 60;
var timePerPrimeNotShowing = 500;
var currentInterval = 0;
var lastChange = 0;
var maskIt = true;
var whichSet= 0;


  function setup() {
    createCanvas(800, 800);
    textSize(24);
    textAlign(CENTER)
    textFont("Helvetica");
    frameRate(1000);
  }

function draw() {
  background(255);
  if (maskIt) {
    text(maskingWord, width/2, height/2);
    currentInterval = timePerPrimeNotShowing;
  } else {
    text(words[whichSet].prime, width/2,  height/2);
     currentInterval = timePerPrimeShowing;
  }
  
  if (millis() - lastChange > currentInterval){
    maskIt = ! maskIt;
    lastChange = millis();
  }
  
  text(words[whichSet].option1, width/4, 100);
  line(width/2,0,width/2,100);
  text(words[whichSet].option2, 3*width/4, 100);

}

function mousePressed(){
  if (mouseX > width/2){
    print("Primed with " + words[whichSet].prime + " Picked " + words[whichSet].option1 + " instead of " + words[whichSet].option2 );
  }else{
    print("Primed with " + words[whichSet].prime + " Picked " + words[whichSet].option2 + " instead of " + words[whichSet].option2 );
  }
  whichSet++;
  if (whichSet >= words.length) whichSet = 0;
}
