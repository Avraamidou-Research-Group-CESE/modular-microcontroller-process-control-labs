# Lab 1 — Calibration

**Goal:** introduce the hardware and the Arduino/Simulink toolchain, and generate
calibration curves for the pump (power → flow rate) and the load cell
(reading → water volume).

## Learning outcomes
- Identify the physical components of a process control scheme.
- Generate and interpret calibration data for a sensor and an actuator.

## Files
| File | Purpose |
|------|---------|
| `Lab_1_Worksheet.pdf` / `.docx` | Student worksheet: background, wiring, procedure, deliverables. |
| `Lab_1_Arduino.ino` | Reads the load cell (NAU7802) and writes the value to Simulink; reads a pump-power % setpoint back from Simulink. Requires the **Adafruit NAU7802** library. |
| `Lab_1_Simulink.slx` | Displays the live load-cell reading and sends the pump-power setpoint over serial. |
| `pump_only.slx` | Optional simplified model that drives **only the pump** — handy for testing the pump before the load cell is added. |

## Procedure (summary)
1. Wire the pump + L9110H driver + load cell to the Arduino using the breadboard
   (see the worksheet diagram). **Have an instructor check the wiring before applying power.**
2. Upload `Lab_1_Arduino.ino`; note the COM port.
3. Open `Lab_1_Simulink.slx`, set the COM port in the serial blocks, and run.
4. **Pump calibration:** step the pump power (e.g. 50, 60, … 100 %) and time how
   long it takes to move a fixed volume of water; plot power vs. flow rate.
5. **Load-cell calibration:** record the reading for the empty beaker, then at each
   100 mL increment up to 500 mL; plot reading vs. volume.

## Deliverable
Both calibration curves and the equations that fit them.
