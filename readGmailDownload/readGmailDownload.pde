BufferedReader reader;
String line;
long count =0;
String boundary = null;
String message = "";
String date;
String subject;
String from;
String cc;
String to;

String delimiters = " ,.?!;:[]";

IntDict words;

void setup() {
  size(800, 800);
  words = new IntDict();
  // Open the file from the createWriter() example
  reader = createReader("/Users/dano/Downloads/mail.txt");
  while (true) {
    print("poo");
    try {
      line = reader.readLine();
      count++;
    } 
    catch (IOException e) {
      e.printStackTrace();
      line = null;
    }
    if (line == null|| count >50000) {
      break;
    } 
    else {
      //println(line); 
      if (boundary != null && ! line.startsWith("Content-Transfer-Encoding: ") && ! line.startsWith("Content-Type: ")) {
        //these lines are following a starting boundary so gather them up
        message = message + line;
      }
      //if we are before a starting boundary, gather the header info
      else if ( line.startsWith("Date:")) {
        date = line;
      }
      else if ( line.startsWith("Subject:")) {
        subject = line;
      }
      else if ( line.startsWith("From:")) {
        from = line;
      }
      else if ( line.startsWith("To:")) {
        to = line;
      }
      else if ( line.startsWith("Cc:")) {
        cc = line;
      }
      if (line.startsWith("--")) {  //this is what boundaries start with
        if (boundary == null) {
          //if this is a beginning boundary, set it as the boundary
          boundary = line ;
        }
        else if (line.equals(boundary + "--")) {
          //if you already have a boundary, look for matching end boundary
          //this means you have come to the end of the message
          String[] parts = split(message, boundary); 
          //email usually comes with two versions first plain then html
          String plainText = parts[0];
          String[] theseWords = splitTokens(plainText, delimiters);
          for (int i = 0; i < theseWords.length; i++) {
            String s = theseWords[i].toLowerCase();
            //add it to the int dict
            words.increment(s);
          }
          println(from);
          println(to);
          println(date);
          println(subject);
          println(plainText);
          println("");
          println("");
          message = "";
          boundary = null;
        }
      }
    }
  }
  println("done");
  words.sortValuesReverse();
  //display a graph of the words.
  int h = 20;
  String[] keys = words.keyArray();
  for (int i = 0; i < height/h; i++) {
    String theword = keys[i];
    int count = words.get(theword);

    fill(51);
    rect(0, i*20, count/4, h-4);
    fill(0);
    text(theword, 10+count/4, i*h+h/2);
    stroke(0);
  }
}

void draw() {
} 

