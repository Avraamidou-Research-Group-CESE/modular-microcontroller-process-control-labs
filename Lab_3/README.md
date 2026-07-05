# Lab 3 — Feedback Control

**Goal:** implement feedback level control on the same setup as Lab 2, observe
steady-state offset under P control, and tune a PI controller.

## Learning outcomes
- Assemble a feedback process-control scheme.
- Investigate the effect of the tuning parameters on control performance.

## Theory in brief
The controller acts on the error `ε = y_d − y_m` between the fullness setpoint and
the measured level. Under **proportional-only** control a first-order process
retains a steady-state offset `ε_ss = A / (1 + K_c K_p)`, which shrinks with gain
but never reaches zero. Adding **integral** action removes the offset. In the
Simulink PID block the proportional (`P`) and integral (`I`) gains are set
independently.

## Files
| File | Purpose |
|------|---------|
| `Lab_3_Worksheet.pdf` / `.docx` | Worksheet: feedback theory, block diagram, procedure, deliverables. |
| `Lab_3_Arduino_Setup.ino` | Setup sketch to check the scale and record empty/full readings. |
| `Lab_3_Simulink_Setup.slx` | Companion Simulink model for the setup step. |
| `Lab_3_Arduino.ino` | Main sketch: reads the scale, applies an outlet-pump disturbance profile, and takes the inlet pump power from the controller. **Edit the `empty`/`full` constants.** |
| `Lab_3_Simulink.slx` | Contains the PI controller (set `P` and `I`) that manipulates the inlet pump to hold the fullness setpoint. |
| `Lab_3_MATLAB.m` | Prompts for the `P`/`I` values, plots controlled vs. manipulated vs. setpoint, reports **RMSE**, and saves a PNG + CSV per run. |

## Procedure (summary)
1. Wire and check as in Lab 2; run the **setup** step and enter the empty/full
   readings into `Lab_3_Arduino.ino`.
2. Upload `Lab_3_Arduino.ino`, open `Lab_3_Simulink.slx`, set the COM ports.
3. Start with **P only** (e.g. `P = 5, I = 0`); give a setpoint (e.g. 50 %), let it
   settle, then change the setpoint and observe the **steady-state offset**.
4. Add integral action and sweep `P` and `I` (e.g. `P = [1, 5, 10]`,
   `I = [0.1, 2, 5]`); run `Lab_3_MATLAB.m` after each to record RMSE and response.
5. Choose the "best" `P`/`I` and justify the choice.

## Deliverable
A report with the setup description, a labeled block diagram, a table of `P`/`I`
values and metrics (response time, RMSE, overshoot, offset), response plots, and
the reasoning for the chosen tuning.
