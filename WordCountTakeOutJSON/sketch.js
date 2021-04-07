let history = [];
let index = {};
let keys = []

function preload(){
  console.log("loading");
 //history = loadJSON("BrowserHistory.json");
 history = loadJSON("MyActivity.json");

}

function setup(){
    createCanvas(400,400);
    //history = history['Browser History'];  //browser history is one level in
    history = history['myActivity'];  //if you surround your json with {"myActivity": ...... millions of lines ... }  you will get length to work
    //otherwise you have to hard code the length in like 100000 in for loop, go figure.
    console.log(history.length);
    for(var i = 0; i < history.length; i++){
     // var date = new Date(history[i].time_usec/1000); // create Date object if time is given in milliseconds or even usecs
     //var date = history[i].time;
      let words = history[i].title.split(" ");
      for(var j = 0; j < words.length; j++){
        let thisWord = words[j];
    
        if ( index[thisWord ] == null ) {
          index[thisWord ] = 1;
          keys.push(thisWord);
        }else{
          index[thisWord ] += 1 ;
        }
      }
    }

  keys.sort(function(a,b) {
      return index[b] - index[a];
  });
  for(var i = 0 ; i < 100; i++){
    let key = keys[i];
    console.log(key , index[key]);
  }

}

function draw(){

}