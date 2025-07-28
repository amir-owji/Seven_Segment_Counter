# Seven Segment Counter Project
7-Segment counter with adjustable speed using VHDL

Overview

This is a VHDL-based project that implements a 7-Segment counter, designed and simulated using Vivado 2019. 

The counter displays numbers 0 to 9 on a 7-Segment display with adjustable speeds (1Hz, 2Hz, 4Hz) controlled by two buttons.

Features

Clock Divider: Divides a 50MHz clock to 1Hz, 2Hz, or 4Hz based on speed selection.

Binary Counter: Counts from 0 to 9 using the divided clock.

7-Segment Decoder: Converts the binary count to 7-Segment patterns (Common Anode).

Speed Control: Adjusts speed using up and down buttons with debounce filtering (10ms).

How to Use

Add all .vhd files to a Vivado 2019 project.

Set seven_segment_counter.vhd as the Top Module.

Simulate using seven_segment_counter_tb.vhd with a simulation time of at least 40ms.

For hardware implementation (e.g., Basys 3), synthesize the design and program the FPGA with proper pin constraints (e.g., .xdc file).

Simulation Results

The counter cycles through 0-9 at selected speeds.

Buttons change the speed after a 10ms debounce period.

<img width="1882" height="512" alt="waveform" src="https://github.com/user-attachments/assets/ac490bdb-4a88-4561-bd47-4a612419ba58" />

Prerequisites

Vivado 2019 or later.

An FPGA board (e.g., Basys 3) for hardware testing.

Contact

LinkedIn: www.linkedin.com/in/amir-hossein-owji

GitHub: https://github.com/amir-owji

Email: amir.owji003@gmail.com
