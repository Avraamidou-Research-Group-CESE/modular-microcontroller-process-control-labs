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
int inlet_pin = 5; // connect IA of inlet pump to Arduino pin 5 (PWM)

float inlet_percentage = 80; // starting inlet percentage
const float full = 394000; // scale reading when filled to 500 mL and pump
const float empty = 345000; // scale reading with empty beaker and pump

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

  pinMode(inlet_pin, OUTPUT);
  analogWrite(inlet_pin, 0);
}

// continous loop to read scale and set pump power
void loop() {
  float scale_value = scale.read(); // get the scale value 
  float fullness = (scale_value - empty) / (full - empty) * 100; // convert to percent fullness
  writeToMatlab(fullness); // write the scale value to MATLAB

  while(fullness > 120 || fullness < 0) {
    scale_value = scale.read();
    fullness = map(scale_value, empty, full, 0, 100);
    delay(1);
  }

  if (Serial.available() > 0) {
    inlet_percentage = readFromMatlab(); // read inlet pump percent power from MATLAB
    Serial.read();
  }

  int pwmValue_inlet = map(inlet_percentage,0,100,0,255); // map to PWM range
  analogWrite(inlet_pin, pwmValue_inlet); // cset the inlet flow rate
  
  //float outlet_percentage = 15 * sin(millis()/1000 * 2 * PI / 20) + 65; // Sine wave with period of 20 seconds, ranging between 50 and 80
  //float outlet_percentage = 70; // keep outlet power constant
  float outlet_percentage = map(scale_value, empty, full, 50, 75); // outlet power proportional to height
  int pwmValue_outlet = map(outlet_percentage,0,100,0,255); // map to PWM range
  analogWrite(outlet_pin, pwmValue_outlet); // set outlet flow rate

  delay(50);
}