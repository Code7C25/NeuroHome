int bombaAgua = 8;

void setup () {
  pinMode (bombaAgua,OUTPUT);
  }

void loop () {
  digitalWrite(bombaAgua, LOW);
  delay(8000);

  digitalWrite (bombaAgua, HIGH);
  delay(1000);

}