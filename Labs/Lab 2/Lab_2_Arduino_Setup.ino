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
int outlet_pin = 10; // connect IA of outlet pump to Arduino pin 10 (PWM)
float outlet_percentage = 0; // starting outlet percentage

void setup() {
  Serial.begin(9600, SERIAL_8N1); // begin serial
  Wire.begin();

  // check for and setup scale
  if (!scale.begin()) {
    Serial.println("NAU7802 not detected. Please check wiring.");
    while (1);
  }

  if (!scale.calibrate(NAU7802_CALMOD_INTERNAL)) {
    Serial.println("Calibration failed. Check if the load cell is properly connected and try again.");
    while (1);
  }

  // empty serial before beigning
  Serial.flush();
  Serial.read(); 

  // Initialize the control pins as outputs
  pinMode(outlet_pin, OUTPUT);
  analogWrite(outlet_pin, 0);
}

// continous loop to read scale and set pump power
void loop() {
  float scale_value = scale.read(); // get the scale value 
  writeToMatlab(scale_value); // write the scale value to serial

  if (Serial.available() > 0) {
    outlet_percentage = readFromMatlab(); // read outlet pump percent power from matlab
    Serial.read();
  }
  
  int pwmValue_outlet = outlet_percentage / 100 * 255; // get pump power value and mapt to a PWM value (0 to 255)
  analogWrite(outlet_pin,pwmValue_outlet); // control outlet flow rate

  delay(50);
}