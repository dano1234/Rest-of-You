int breath ;
int light ;
int heat;
int sweat;
int posture;
int electricity;

void setup() {
Serial.begin(9600);
//  Serial.println("Start");
}

void loop() {
  


electricity = analogRead(0);
Serial.print(electricity);
Serial.print(",");

sweat = analogRead(1);
Serial.print(sweat);
Serial.print(",");

heat = analogRead(2);
Serial.print(heat);
Serial.print(",");


light = analogRead(3);
Serial.print(light);
Serial.print(",");
/*
posture = analogRead(4);
Serial.print(posture);
Serial.print(",");
*/
breath = analogRead(5);
Serial.print(breath);
Serial.print(",");

Serial.write(10);

}

