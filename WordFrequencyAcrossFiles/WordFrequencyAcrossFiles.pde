import java.util.*;
import java.io.*;

int numberOfPeople;
int numberOfSegment;
//ArrayList names = new ArrayList();
ArrayList reSortable= new ArrayList( ) ;
;  //array that gets resorted by person or by Segment
int SegmentOrPerson = 0;  //0 is Segment 1 is person
int focus = 15;
TreeMap wordObjects = new TreeMap();  //words in alphabetical order
static int sortBy = 0;
static int BY_Segment = 1;
static int BY_TOTAL = 0;
int borderWord = 50;
int[] SegmentTotals;

void setup() {
  String directory = "/Users/dano/Documents/Rest-of-You/WordFrequencyAcrossFiles/Data/";
  //String directory = "/Volumes/Crucial/ThesisTXT/";
  size(800, 800);
  // String directory = "D:\\ThesisTXT\\";



  File dir = new File(directory);
  String[] files = dir.list();
    numberOfSegment = files.length;
  numberOfPeople = files.length;
   SegmentTotals= new int[numberOfSegment];

  for (int i=0; i<files.length; i++) {
    // Get filename of file or directory

    String filename = files[i];
    if (filename.startsWith(".")) continue;
    println (filename);
    String[] parts = filename.split("\\.");

    //int theSegment = -1;
    //would have been helpful to have Segment in a predictable place
  //  for (int j = 0; j < parts.length; j++) { //should use regex
    //  if (parts[j].startsWith("19") || parts[j].startsWith("20")) {
     //   theSegment = int(parts[j]);
     //   break;
     // }
  //  }

    //if (theSegment < 1970) theSegment = 1972;
    
   // SegmentTotals[theSegment-1970]++;
   // String name = parts[1] + " " + parts[2];
   int theSegment = i;
   //String name = filename;
    //names.add(name);
    String[] myLines = loadStrings(directory  + filename);
    String allText = join(myLines, " ");
    String[] words = allText.split(" ");

    for (int j = 0; j < words.length; j++) {
      String wordString = words[j].toLowerCase();
      Word thisWord = (Word) wordObjects.get(wordString);
      if (thisWord == null) {
        Word newWord = new Word(wordString);
        wordObjects.put(wordString, newWord);
        reSortable.add(newWord);
        newWord.usedAt(theSegment, i);
      }
      else {
        thisWord.usedAt(theSegment, i);
      }
    }
  }
  drawWords();
}
void  setSort(int _whichWay) {
  sortBy = _whichWay;
}
void draw() {
}

void drawWords() {
  background(0);
  int total = 0; //find the average number of occurances
  setSort(BY_TOTAL);
  Collections.sort(reSortable);
  int border = min(reSortable.size()-1,borderWord);
  if (border < 0) return;
  Word theWord= (Word) reSortable.get(border);
  int cutoffFrequency = theWord.total;

  int ypos = 30;
  int xpos = 100;
  text("Segment: " + (focus ), xpos, 10);
  setSort(BY_Segment);
  Collections.sort(reSortable);
  for (int j = 0; j < reSortable.size(); j++) {
    Word thisWord = (Word) reSortable.get(j);
    //find things that are below average in the total but prominent this month
    //this is a hack of more precise bayesian math
    //for better math: http://7in7.tumblr.com/post/38431191/ive-adapted-my-spam-filtering-example-from
    //or http://www.decontextualize.com/teaching/a2z/bayesed-and-confused/
    //or http://www.shiffman.net/teaching/a2z/bayesian/
    if (thisWord.total < cutoffFrequency && thisWord.word.length() > 4) {
      
      // int xpos = i * width / numberOfParts;
      ypos = ypos + 11;
      if (ypos > height) break;
      //text(thisWord.partsOfSegment[i] + thisWord.word, xpos, ypos);
      text(thisWord.word + " (Segment:" + thisWord.Segment[focus] + ")"+ " (Total:" + thisWord.total + ")", xpos, ypos);
    }
  }
}

public void keyPressed() {
  if (keyCode == 37) {
    focus = max(focus-1, 0);
  }
  else if (keyCode == 39) {
    focus = min(focus+1, numberOfSegment-1);
  }  if (keyCode == 38) {
    borderWord = max(borderWord-1, 0);
  }
  else if (keyCode == 40) {
    borderWord = min(borderWord+1, reSortable.size()-1);
  }
  println(borderWord);
  drawWords();
}

public class Word implements Comparable {


  int[] Segment = new int[numberOfSegment];
  float[] SegmentPercent = new float[numberOfSegment];

  // int[] people = new int[numberOfPeople];
  public int total;
  String word;
  public Word(String _word) {
    word = _word;
  }



  public void usedAt(int _Segment, int _person) {
    Segment[_Segment ]++;
    // people[_person]++;
    total++;
  }

  public int compareTo(Object _other) {
    if (sortBy == BY_Segment) {
      if (Segment[focus] - ((Word) _other).Segment[focus] >= 1)
        return -1;
      else
        return 1;
    }
    else if (sortBy == BY_TOTAL) {
      if (total - ((Word) _other).total >= 1)
        return -1;
      else
        return 1;
    }
    return 1;

  }
}
