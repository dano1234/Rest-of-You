int numberOfPeople;
int numberOfYears;
ArrayList names = new ArrayList();
ArrayList reSortable= new ArrayList( ) ;
;  //array that gets resorted by person or by year
int yearOrPerson = 0;  //0 is year 1 is person
int focus = 15;
TreeMap wordObjects = new TreeMap();  //words in alphabetical order
static int sortBy = 0;
static int BY_YEAR = 1;
static int BY_TOTAL = 0;
int borderWord = 50;
int[] yearTotals;

void setup() {
  String directory = "/Volumes/Crucial/ThesisTXT/";
  size(800, 800);
  // String directory = "D:\\ThesisTXT\\";

  numberOfYears = year() - 1970;

  File dir = new File(directory);
  String[] files = dir.list();
  numberOfPeople = files.length;
   yearTotals= new int[numberOfYears];

  for (int i=0; i&lt;files.length; i++) {
    // Get filename of file or directory

    String filename = files[i];
    if (filename.startsWith(".")) continue;
    println (filename);
    String[] parts = filename.split("\\.");

    int theYear = -1;
    //would have been helpful to have year in a predictable place
    for (int j = 0; j &lt; parts.length; j++) { //should use regex
      if (parts[j].startsWith("19") || parts[j].startsWith("20")) {
        theYear = int(parts[j]);
        break;
      }
    }

    if (theYear &lt; 1970) continue;
    yearTotals[theYear-1970]++;
    String name = parts[1] + " " + parts[2];
    names.add(name);
    String[] myLines = loadStrings(directory  + filename);
    String allText = join(myLines, " ");
    String[] words = allText.split(" ");

    for (int j = 0; j &lt; words.length; j++) {
      String wordString = words[j].toLowerCase();
      Word thisWord = (Word) wordObjects.get(wordString);
      if (thisWord == null) {
        Word newWord = new Word(wordString);
        wordObjects.put(wordString, newWord);
        reSortable.add(newWord);
        newWord.usedAt(theYear, i);
      }
      else {
        thisWord.usedAt(theYear, i);
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

  Word theWord= (Word) reSortable.get(borderWord);
  int cutoffFrequency = theWord.total;

  int ypos = 30;
  int xpos = 100;
  text("Year: " + (focus + 1970), xpos, 10);
  setSort(BY_YEAR);
  Collections.sort(reSortable);
  for (int j = 0; j &lt; reSortable.size(); j++) {
    Word thisWord = (Word) reSortable.get(j);
    //find things that are below average in the total but prominent this month
    //this is a hack of more precise bayesian math
    //for better math: http://7in7.tumblr.com/post/38431191/ive-adapted-my-spam-filtering-example-from
    //or http://www.decontextualize.com/teaching/a2z/bayesed-and-confused/
    //or http://www.shiffman.net/teaching/a2z/bayesian/
    if (thisWord.total &lt; cutoffFrequency &amp;&amp; thisWord.word.length() &gt; 4) {
      
      // int xpos = i * width / numberOfParts;
      ypos = ypos + 11;
      if (ypos &gt; height) break;
      //text(thisWord.partsOfYear[i] + thisWord.word, xpos, ypos);
      text(thisWord.word + " (Y:" + thisWord.years[focus] + ")"+ " (T:" + thisWord.total + ")", xpos, ypos);
    }
  }
}

public void keyPressed() {
  if (keyCode == 37) {
    focus = max(focus-1, 0);
  }
  else if (keyCode == 39) {
    focus = min(focus+1, numberOfYears-1);
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


  int[] years = new int[numberOfYears];
  float[] yearPercent = new float[numberOfYears];

  // int[] people = new int[numberOfPeople];
  public int total;
  String word;
  public Word(String _word) {
    word = _word;
  }



  public void usedAt(int _year, int _person) {
    years[_year -1970]++;
    // people[_person]++;
    total++;
  }

  public int compareTo(Object _other) {
    if (sortBy == BY_YEAR) {
      if (years[focus] - ((Word) _other).years[focus] &gt;= 1)
        return -1;
      else
        return 1;
    }
    else if (sortBy == BY_TOTAL) {
      if (total - ((Word) _other).total &gt;= 1)
        return -1;
      else
        return 1;
    }
    return 1;

  }
}
