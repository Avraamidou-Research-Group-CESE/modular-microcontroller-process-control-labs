#include <Wire.h>
#include <Adafruit_NAU7802.h>

// reading and writing to MATLAB SIimulink

union BtoF
{
  byte b[16];
  float fval;
} u;

const int buffer_size = 16;
byte buf[buffer_size];

float readFromMatlab()
{
  int reln = Serial.readBytesUntil("\r\n", buf, buffer_size);
  for (int i=0; i<buffer_size; i++)
  {
    u.b[i] = buf[i];
  }
  float output = u.fval;
  return output;
}

void writeToMatlab (float number)
{
  byte *b = (byte *) &number;
  Serial.write(b, 4);
  Serial.write(13);
  Serial.write(10);
}

// Initiate scale to get values

Adafruit_NAU7802 scale;

// Setup pumps and scale
int speedPin = 10; // Connect A-IA to Arduino pin 11 (PWM)

void setup() {
  Serial.begin(9600, SERIAL_8N1);
  Wire.begin();

  if (!scale.begin()) {
    Serial.println("NAU7802 not detected. Please check wiring.");
    while (1);
  }

  scale.setLDO(NAU7802_3V0);
  scale.setGain(NAU7802_GAIN_128); 
  scale.setRate(NAU7802_RATE_10SPS);
  if (!scale.calibrate(NAU7802_CALMOD_INTERNAL)) {
    Serial.println("Calibration failed. Check if the load cell is properly connected and try again.");
    while (1);
  }

  Serial.flush();
  Serial.read(); // Clear the buffer

  // Initialize the control pins as outputs
  pinMode(speedPin, OUTPUT);
  analogWrite(speedPin, 0);
}

// continous loop to read scale and set pump power
void loop() {
  // put your main code here, to run repeatedly:
  if (Serial.available() > 0)
  {
    float weight = scale.read(); // get the scale value 
    writeToMatlab(weight); // write the scale value to serial

    float outlet_percentage = readFromMatlab();
    int pwmValue = map(outlet_percentage, 0, 100, 0, 255); // Map the percentage to a PWM value (0 to 255)
    analogWrite(speedPin, pwmValue); // Control the speed
  }
  delay(1);
}