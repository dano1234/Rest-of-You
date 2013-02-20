/*Install a keystroke logging program.

Logging keystrokes would be an easy application for you to write yourself but for security reasons it is not permitted to trap keystrokes in the background in java (processing). First find keylogging software that writes a file full of all your keystrokes. I did not write these and so am a little distrustful of them but they did work for me and my bank account is still there.

* Mac http://code.google.com/p/logkext/ logKext runs in back ground
* PC http://www.spyarsenal.com/familykeylogger/ "Family" Keylogger

Analalyze the Resulting File

Then write a program to count your words, then find a way to pick out the most <a href="http://itp.nyu.edu/~dbo3/roy/?p=24">interesting words</a>. Sometimes you talk to your keylogger using your terminal. Finding the file that you keylogger is making can be difficult. Check the instructions.
<img title="More..." src="../../../%7Edbo3/roy2010/wp-includes/js/tinymce/plugins/wordpress/img/trans.gif" alt="" />
*/

import java.util.*;

TreeMap wordCounts = new TreeMap();

void setup(){
  String [] myLines = loadStrings("http://www.gutenberg.org/cache/epub/15/pg15.txt");

  //String [] myLines = loadStrings("/Users/dano/Desktop/out_logFile.txt");

  String allText = join(myLines,"");

  allText = allText.replaceAll("\\[SHFT\\]","");

  allText = allText.replaceAll("\\[CMD\\]","");

  allText = allText.replaceAll("\\[DEL\\]","");

  String[] words = allText.split(" ");

  for (int i = 0; i < words.length; i++){

    Integer thisWordCount = (Integer) wordCounts.get(words[i]);

    if (thisWordCount == null){

      wordCounts.put(words[i], new Integer(1));

    }
    else{

      println("exists" + words[i]);

      thisWordCount = new Integer(thisWordCount.intValue() + 1);

      wordCounts.put(words[i], thisWordCount);

    }

  }

  Object[] keys = wordCounts.keySet().toArray();

  for(int i = 0; i < keys.length; i++){

    Integer count = (Integer) wordCounts.get(keys[i]);

    if (count.intValue() > 1){

      println(keys[i] + " " + count.intValue());

    }

  }

}

void draw(){

}
