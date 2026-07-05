# Modular Microcontroller-Based Process Control Labs

A set of **three low-cost, self-contained Arduino experiments** for teaching
process dynamics and control. They were developed for *CBE 470: Process Dynamics
and Control* at the University of Wisconsin–Madison to deliver hands-on control
experience in an ordinary lecture hall — no teaching-laboratory space required.

Each group builds a small water-level control system on a breadboard, calibrates
its sensor and actuator, identifies a first-order process model, and designs and
tunes a P/PI level controller. The full kit costs about **\$74.77 per group**.

> Developed by the [Avraamidou Research Group (CESE)](https://github.com/Avraamidou-Research-Group-CESE),
> Department of Chemical and Biological Engineering, University of Wisconsin–Madison.

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

## Equipment (per group — total ≈ \$74.77)

| Component | Qty | Unit cost | Supplier |
|-----------|:---:|:---------:|----------|
| Arduino UNO REV3 | 1 | \$27.60 | Arduino (via Amazon) |
| USB Cable – 6″ A-B | 1 | \$2.95 | Adafruit |
| Half-sized premium breadboard | 1 | \$5.00 | Adafruit |
| Breadboarding wire bundle | 1 | \$4.95 | Adafruit |
| Submersible 3 V DC water pump | 2 | \$2.95 | Adafruit |
| PVC tubing, 6 mm ID (1 m) | 1 | \$1.50 | Adafruit |
| L9110H H-bridge motor driver | 2 | \$1.50 | Adafruit |
| Alligator-clip-to-male bundle | 1 | \$3.95 | Adafruit |
| 20 kg digital load cell kit (NAU7802) | 1 | \$15.99 | Geekstory (via Amazon) |
| STEMMA QT 4-pin to male | 1 | \$0.95 | Adafruit |
| 500 mL plastic beaker | 2 | \$0.45 | Uline |
| Microfiber cloth | 1 | \$0.83 | Amazon |
| Plastic bin | 1 | \$1.25 | Target |

See [`Equipment.xlsx`](Equipment.xlsx) for the complete bill of materials.

## Software requirements

- **[Arduino IDE](https://www.arduino.cc/en/software)** — to edit and upload the `.ino` sketches.
- **Adafruit NAU7802 library** — install via the Arduino IDE Library Manager
  (*Sketch → Include Library → Manage Libraries → "Adafruit NAU7802"*).
- **MATLAB with Simulink** and the **System Identification Toolbox** (Lab 2).
  The labs were developed and tested on **MATLAB R2023b**.
  > ⚠️ On **R2024a** some students hit issues installing a required Simulink
  > hardware-support package. If you run into problems, R2023b is the known-good
  > version.

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

If you use these materials, please cite the accompanying paper:

> B. Lopez, P. Brahmbhatt, M.-L. Tsai, S. Avraamidou. *Modular
> Microcontroller-based Laboratories in Process Dynamics and Control.*
> (Submitted to *Education for Chemical Engineers*.)

## License

Released under the [MIT License](LICENSE) © 2026 Avraamidou Research Group.

## Acknowledgment

Supported by the Department of Chemical and Biological Engineering, University of
Wisconsin–Madison.
