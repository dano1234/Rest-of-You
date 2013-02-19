public class DataField {

  int myColor = 0;
  int biggestValueEver = 0;
  int smallestValueEver = Integer.MAX_VALUE;
  int lastReading = 0;
  int consecutiveThreshold = 7;
  byte[] transitions;
  int lastTransition = 0;
  int consecutiveDown = 0;
  int consecutiveUp = 0;
  int lastMark;
  int[] values;

  String fieldName;

  public DataField(int _rows, int _consecutiveThreshold, String _fieldName, int _color) {
    fieldName = _fieldName;
    myColor = _color;
    consecutiveThreshold = _consecutiveThreshold;
    transitions = new byte[_rows];
    values = new int[_rows];
  }

  public void setValue(int _readingNumber, int _reading) {
    if (_reading < smallestValueEver) smallestValueEver = _reading; // 0 is minimum
    if (_reading > biggestValueEver) biggestValueEver = _reading; // 1 is maximum
    values[_readingNumber] = _reading;
  }

  public int getValue(int _readingNumber) {
    return values[_readingNumber];
  }

  public int getColor() {
    return myColor;
  }

  public void checkForPeak(int _readingNumber, int _reading) {

    int difference = _reading - lastReading;
    if (difference < 0) {
      consecutiveDown++;
      consecutiveUp = 0;
    }
    if (difference > 0) {
      consecutiveDown = 0;
      consecutiveUp++;
    }

    if (lastTransition >= 0 && consecutiveUp > consecutiveThreshold) { // last one was a peak and you are going up again mark this valley
      lastTransition = -1; // last one
      // satified there is a trend now go find the lowest since we last marked.
      int lowest = Integer.MAX_VALUE;
      int winningPos = 0;
      for (int i = _readingNumber; i > lastMark; i--) {
        if (values[i] < lowest) {
          lowest = values[i];
          winningPos = i;
        }
      }
      lastMark = _readingNumber;
      // mark a valley
      transitions[winningPos] = -1;
    }
    if (lastTransition <= 0 && consecutiveDown > consecutiveThreshold) { // last one was a valley and you are going down again mark this peak
      lastTransition = 1; // last one
      // satified there is a trend now go find the lowest since we last marked.
      int highest = 0;
      int winningPos = 0;
      for (int i = _readingNumber; i > lastMark; i--) {
        if (values[i] > highest) {
          highest = values[i];
          winningPos = i;
        }
      }
      lastMark = _readingNumber;
      // mark a peak
      transitions[winningPos] = 1;
      // transitions[_readingNumber-consecutiveDown] = 1;
    }

    lastReading = _reading;
  }

  public int isAPeak(int _placeInArray) {
    return (transitions[_placeInArray]);
  }
}

