# Lab 2 — System Identification

**Goal:** generate step-response data for the water-level system and fit a
first-order (with optional time delay) process model.

## Learning outcomes
- Generate system-response data to a step input.
- Develop a first-order process model from response data.

## Setup
A two-pump, two-beaker arrangement emulates a single tank with an uncontrolled
outlet: the **inlet pump** delivers the manipulated inflow, and the **outlet
pump** is driven at a power proportional to the measured beaker weight,
reproducing a linear outlet resistance. The result behaves as a first-order
process, `g(s) = K_p / (τs + 1)`.

## Files
| File | Purpose |
|------|---------|
| `Lab_2_Worksheet.pdf` / `.docx` | Worksheet: theory (first-order dynamics), wiring, procedure, deliverables. |
| `Lab_2_Arduino_Setup.ino` | Setup sketch to check the scale and record the empty/full readings. |
| `Lab_2_Simulink_Setup.slx` | Companion Simulink model for the setup/calibration step. |
| `Lab_2_Arduino.ino` | Main sketch: reads the scale, drives the outlet pump proportional to fullness, and takes the inlet pump power from Simulink. **Edit the `empty`/`full` constants** with your recorded readings. |
| `Lab_2_Simulink.slx` | Sends the inlet pump-power setpoint and logs the response. |
| `Lab_2_MATLAB.m` | Visualizes and saves the step-response data to `Lab_2_Data.csv`. |
| `Lab_2_MATLAB_Data.m` | Loads `Lab_2_Data.csv` back into MATLAB for further processing. |
| `Lab_2_MATLAB_Modeling.m` | Fits a first-order model with `tfest` and overlays model vs. data. |

## Procedure (summary)
1. Wire the two pumps + driver + load cell; **instructor check before power.**
2. Run the **setup** sketch/model; record the empty and full scale readings and
   enter them into `Lab_2_Arduino.ino`.
3. Upload `Lab_2_Arduino.ino`, open `Lab_2_Simulink.slx`, set the COM ports.
4. Start the inlet pump at 100 %, let the level reach steady state, then **step
   the inlet power down to 70 %** and let it settle.
5. Run `Lab_2_MATLAB.m` to save the data, then `Lab_2_MATLAB_Modeling.m` (or the
   System Identification Toolbox) to fit the model.

## Deliverable
The data CSV and a short report: experiment description, any filtering, the model
fit (code + explanation), model selection, and a plot of data vs. model.
