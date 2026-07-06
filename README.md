# Modular Microcontroller-Based Process Control Labs

A set of **three low-cost, self-contained Arduino experiments** for teaching
process dynamics and control. They were developed for *CBE 470: Process Dynamics
and Control* at the University of Wisconsin–Madison to deliver hands-on control
experience in an ordinary lecture hall — no teaching-laboratory space required.

Each group builds a small water-level control system on a breadboard, calibrates
its sensor and actuator, identifies a first-order process model, and designs and
tunes a P/PI level controller. The full kit costs about **\$74.77 per group**.

---

## The three labs

| Lab | Topic | Students learn to… |
|-----|-------|--------------------|
| **[Lab 1](Lab_1/)** | Calibration | Wire the load cell + pump, use the Arduino IDE and serial communication, and generate calibration curves for the pump and load cell. |
| **[Lab 2](Lab_2/)** | System Identification | Apply a step input, collect the response, and fit a first-order (with time delay) process model using the System Identification Toolbox. |
| **[Lab 3](Lab_3/)** | Feedback Control | Implement P and PI level control, observe steady-state offset, and tune the controller by trial and error. |

Each lab folder contains its own `README.md`, a student worksheet (`.docx` and
`.pdf`), the Arduino sketch(es), and the MATLAB/Simulink files.

## Repository structure

```
.
├── Lab_1/                 # Calibration
├── Lab_2/                 # System identification
├── Lab_3/                 # Feedback control
├── Resources/             # Component datasheets (NAU7802 ADC, L9110 driver)
├── Equipment.xlsx         # Full bill of materials
├── LICENSE                # MIT
└── README.md
```

The full bill of materials is in [`Equipment.xlsx`](Equipment.xlsx).

## Software requirements

- **[Arduino IDE](https://www.arduino.cc/en/software)** — to edit and upload the `.ino` sketches.
- **Adafruit NAU7802 library** — install via the Arduino IDE Library Manager
  (*Sketch → Include Library → Manage Libraries → "Adafruit NAU7802"*).
- **MATLAB with Simulink** and the **System Identification Toolbox** (Lab 2).

## General workflow

Each lab follows the same pattern (details in the per-lab READMEs and worksheets):

1. **Wire the circuit** on the breadboard following the worksheet diagram, and
   have an instructor check it **before applying power**.
2. **Upload the Arduino sketch** (`Lab_x_Arduino.ino`) from the Arduino IDE, and
   note the assigned **COM port**.
3. **Open the Simulink model** (`Lab_x_Simulink.slx`) and set the COM port in the
   *Serial Configuration*, *Serial Receive*, and *Serial Send* blocks.
4. **Run** the model and record data; the MATLAB scripts (`Lab_x_MATLAB*.m`)
   visualize and save the results.

The Arduino and Simulink exchange data over a simple byte-wise serial link — the
Arduino reads the load cell and writes it to Simulink, and reads a pump-power
setpoint (%) back from Simulink.

## Safety

- Pumps run at **3.3 V** and the load cell at **5 V** — low voltage, but keep
  water away from the Arduino and laptop, and position power sources away from
  the water.
- **Always have an instructor inspect the wiring before power is applied.**
- Keep a towel on hand and assign one team member to unplug the Arduino if a
  spill or fault occurs.

## Citation

If you use these materials, full citation information will be provided after
publication.

## License

Released under the [MIT License](LICENSE) © 2026 Avraamidou Research Group.

## Acknowledgment

Supported by the Department of Chemical and Biological Engineering, University of
Wisconsin–Madison.
