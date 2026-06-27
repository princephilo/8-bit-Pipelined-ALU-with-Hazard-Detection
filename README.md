# 8-bit Pipelined ALU with Hazard Detection

This repository contains a Verilog implementation of an 8-bit Pipelined Arithmetic Logic Unit (ALU) with Hazard Detection and Forwarding.

## Overview

The design features a 3-stage pipeline (Fetch/Decode, Execute, Writeback) and includes data forwarding logic to resolve Read-After-Write (RAW) hazards without requiring pipeline stalls.

### Components
- **ALU (`alu.v`)**: Performs arithmetic and logic operations.
- **Register File (`regfile.v`)**: Contains the registers to store intermediate and final values.
- **Datapath (`datapath.v`)**: A single-cycle datapath implementation.
- **Pipelined Datapath (`pipelined_datapath.v`)**: The 3-stage pipelined datapath featuring data forwarding and hazard detection logic.

### Testbenches
The repository also includes comprehensive testbenches (e.g., `alu_tb.v`, `regfile_tb.v`, `datapath_tb.v`, `pipelined_datapath_tb.v`, `forwarding_tb.v`, and `selfcheck_tb.v`) to verify the functionality and timing of the individual components and the entire pipeline.

## Getting Started

You can run the simulation using any standard Verilog simulator such as Icarus Verilog (`iverilog`) or ModelSim.

### Simulation with Icarus Verilog

1. **Compile the design and testbench:**
   ```bash
   iverilog -o pipe_sim pipelined_datapath.v pipelined_datapath_tb.v alu.v regfile.v
   ```
2. **Run the simulation:**
   ```bash
   vvp pipe_sim
   ```
3. **View the waveforms:**
   Waveform files (`*.vcd`) are generated during simulation and can be viewed using GTKWave.
   ```bash
   gtkwave waves.vcd
   ```
