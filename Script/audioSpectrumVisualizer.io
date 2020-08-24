#include <Adafruit_NeoPixel.h>

const int strobePinR   = 2;    // Strobe Pin on the MSGEQ7
const int resetPinR    = 3;    // Reset Pin on the MSGEQ7
const int outPinR      = A0;   // Output Pin on the MSGEQ7
const int WS2812_PIN_R = 7;
int levelR[7];                 // An array to hold the values from the 7 frequency bands

const int strobePinL   = 5;    // Strobe Pin on the MSGEQ7
const int resetPinL    = 6;    // Reset Pin on the MSGEQ7
const int outPinL      = A1;   // Output Pin on the MSGEQ7
const int WS2812_PIN_L = 4;
int levelL[7];                 // An array to hold the values from the 7 frequency bands

Adafruit_NeoPixel stripR = Adafruit_NeoPixel(49, WS2812_PIN_R, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel stripL = Adafruit_NeoPixel(49, WS2812_PIN_L, NEO_GRB + NEO_KHZ800);

void setup() {

  Serial.begin (9600);

  stripR.begin();
  stripR.show();

  stripL.begin();
  stripL.show();

  // Define our pin modes
  pinMode      (strobePinR, OUTPUT);
  pinMode      (resetPinR,  OUTPUT);
  pinMode      (outPinR,    INPUT);

  pinMode      (strobePinL, OUTPUT);
  pinMode      (resetPinL,  OUTPUT);
  pinMode      (outPinL,    INPUT);

  // Create an initial state for our pins
  digitalWrite (resetPinR,  LOW);
  digitalWrite (strobePinR, LOW);
  delay        (1);

  digitalWrite (resetPinL,  LOW);
  digitalWrite (strobePinL, LOW);
  delay        (1);

  // Reset the MSGEQ7 as per the datasheet timing diagram
  digitalWrite (resetPinR,  HIGH);
  delay        (1);
  digitalWrite (resetPinR,  LOW);
  digitalWrite (strobePinR, HIGH);
  delay        (1);

  digitalWrite (resetPinL,  HIGH);
  delay        (1);
  digitalWrite (resetPinL,  LOW);
  digitalWrite (strobePinL, HIGH);
  delay        (1);
}

void setBarL(byte i, int level)
{
  byte toY = map(level, 100, 950, 0, 7);
    
  for (int y = 0; y < toY; y++)
  {
    stripL.setPixelColor((i*7)+y, stripR.Color(3, 3, 13));
  }
}

void setBarR(byte i, int level)
{
  byte toY = map(level, 100, 950, 0, 7);
    
  for (int y = 0; y < toY; y++)
  {
    stripR.setPixelColor((i*7)+y, stripL.Color(3, 3, 13));
  }
}

void drawBar()
{
  stripR.show();
  stripL.show();
}

void loop() {
  
  // Cycle through each frequency band by pulsing the strobe.
  for (int i = 0; i < 7; i++) {
    digitalWrite       (strobePinR, LOW);
    digitalWrite       (strobePinL, LOW);
    delayMicroseconds  (100);                    // Delay necessary due to timing diagram
    
    levelR[i] =         analogRead (outPinR);
    levelL[i] =         analogRead (outPinL);
    
    digitalWrite       (strobePinR, HIGH);
    digitalWrite       (strobePinL, HIGH);
    delayMicroseconds  (100);                    // Delay necessary due to timing diagram  
  }

  stripR.clear();
  stripL.clear();

  for (int i = 0; i < 7; i++)
  {
    setBarR(i, levelR[i]);
    setBarL(i, levelL[i]);
  }

  drawBar();
}
