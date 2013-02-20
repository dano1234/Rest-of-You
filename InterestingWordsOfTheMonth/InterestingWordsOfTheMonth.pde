/*
This code looks through your keylogging for the year and finds the most 
 interesting words for each month. It collects all the words for the year 
 and ranks them for each month. Then it hilite the words that rank high for the month and below average 
 for the year. This code is a little further along than the word counting 
 code because it uses a Word Objects instead of a simple Hashtable, 
 and it introduces a way to sort those objects. This code is a little phoney because there is more sophisticated bayesian 
 math that you could use to get more precise results (see links in code or syllabus). 
 It also just divides to the text into twelve parts. 
 For that to represent months you would have to coincidentily 
 have to type the same amount every month.
 
 */
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.TreeMap;
import processing.core.PApplet;
import processing.core.PFont;


TreeMap wordObjects;
ArrayList reSortable = new ArrayList( ) ;
static int sortOn = 0;
int numberOfParts = 12;
int average = 0;

public void setup() {
  size(1024, 600); // Stage size
  noStroke(); // No border on the next thing drawn
  PFont font = createFont("ArialMT-12.vlw", 10);
  textFont(font);
  background(0);
  fill(255, 255, 255);
  wordObjects = new TreeMap();
  String [] myLines = loadStrings("MobyDick.txt");
  // String[] myLines = loadStrings("/Users/dano/Desktop/out_logFile.txt");
  // String[] myLines = loadStrings("H:\\out_logFile.txt");
  String allText = join(myLines, " ");
  //allText = executeDeletes(allText, "");
  allText = allText.replaceAll("[^\\w\\s]", "");
  String[] words = allText.split(" ");

  for (int i = 0; i< words.length; i++) {
    String wordString = words[i].toLowerCase();
    Word thisWord = (Word) wordObjects.get(wordString);
    int partOfYear = (int) (numberOfParts * (float) i / words.length);
    if (thisWord == null) {
      Word newWord = new Word(wordString);
      wordObjects.put(wordString, newWord);
      reSortable.add(newWord);
      newWord.usedAt(partOfYear);
    }
    else {
      thisWord.usedAt(partOfYear);
    }
  }
  
  //looking for an average of all words
  //would be better to find an average for each word
  int total = 0; //find the average number of occurances
  for (int j = 0; j < reSortable.size(); j++) {
    Word thisWord = (Word) reSortable.get(j);
    total += thisWord.total;
  }
  average = total / reSortable.size();

  //Draw Headers
  for (int i = 0; i < numberOfParts; i++) {
    int xpos = i * width / numberOfParts;
    int ypos = 20;
    text(i, xpos, ypos);
  }

  for (int i = 0; i < numberOfParts; i++) {
    sortOn = i;
    int ypos = 40;
    Collections.sort(reSortable);
    for (int j = 0; j < reSortable.size(); j++) {
      Word thisWord = (Word) reSortable.get(j);
      //find things that are below average in the total but prominent this month
      //this is a hack of more precise bayesian math
      //for better math: http://7in7.tumblr.com/post/38431191/ive-adapted-my-spam-filtering-example-from
      //or http://www.decontextualize.com/teaching/a2z/bayesed-and-confused/
      //or http://www.shiffman.net/teaching/a2z/bayesian/
      if (thisWord.total < average) {
        int xpos = i * width / numberOfParts;
        ypos = ypos + 11;
        if (ypos > height) break;
        //text(thisWord.partsOfYear[i] + thisWord.word, xpos, ypos);
        text(thisWord.word, xpos, ypos);
      }
    }
  }
}

public class Word implements Comparable {
  int[] partsOfYear = new int[numberOfParts];
  public float total;
  String word;
  public Word(String _word) {
    word = _word;
  }

  public void usedAt(int _partOfYear) {
    partsOfYear[_partOfYear]++;
    total++;
  }

  public int compareTo(Object _other) {
    //this function gets called when you sort the array holding the objects
   // if the object "implements Comparable" 
    //check if the number of times it happened in this part of the  year is more in
    //this object then the other.
    if (partsOfYear[sortOn] - ((Word) _other).partsOfYear[sortOn] >= 1)
      return -1;
    else
      return 1;
  }
}

public void draw() {
}

//this function is just for key stroke logging where you instead of recording
//delete key you pretend to press it.
public String executeDeletes(String _input, String _deleteTag) {
  String goodText = "";
  int lastPlace = 0;
  //String bumuch faster than the string class when you are appending stuff
  StringBuilder sb = new StringBuilder();
  while (true) {
    int newPlace = _input.indexOf(_deleteTag, lastPlace);
    if (newPlace == -1) break;
    //include the good text since the last delete
    if (newPlace > lastPlace+1 ) sb.append(_input.substring(lastPlace, newPlace) ); //goodText = goodText + _input.substring(lastPlace , newPlace);
    //subtract a letter
    sb.deleteCharAt(sb.length()-1); //goodText = goodText.substring(0,goodText.length()-1);
    //move down the text
    lastPlace = newPlace + _deleteTag.length()+1;
  }
  return sb.toString();
  //return goodText;
}


