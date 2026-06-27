# 8-bit Pipelined ALU with Hazard Detection

This repository contains a Verilog implementation of an 8-bit pipelined Arithmetic Logic Unit (ALU) with hazard detection and forwarding.

## Summary

The design implements a three-stage pipeline (Fetch/Decode, Execute, Writeback) and includes forwarding and hazard detection to handle data hazards with minimal stalls. The codebase includes both single-cycle and pipelined datapaths, an ALU implementation, a register file, and multiple testbenches.

## Files of Interest

- `alu.v` — ALU logic (arithmetic and logic operations).
- `regfile.v` — Register file used by the datapath.
- `datapath.v` — Single-cycle datapath implementation.
- `pipelined_datapath.v` — 3-stage pipelined datapath with forwarding and hazard detection.
- `*_tb.v` — Testbenches for components and pipeline (e.g., `alu_tb.v`, `regfile_tb.v`, `pipelined_datapath_tb.v`, `forwarding_tb.v`, `selfcheck_tb.v`).
- `waves.vcd` — Example waveform output from simulation.

## Simulation (Icarus Verilog)

1. Compile the design and testbench:

```bash
iverilog -o pipe_sim pipelined_datapath.v pipelined_datapath_tb.v alu.v regfile.v
```

2. Run the simulation:

```bash
vvp pipe_sim
```

3. View the waveform in GTKWave:

```bash
gtkwave waves.vcd
```

## Waveform Screenshot

If you want the waveform screenshot to appear directly in this README, place the waveform image at `images/waves.png`. When present, it will be displayed below.



---

If you'd like, I can add the screenshot file directly to the repository and push the changes to GitHub — provide the image file or confirm that I should use the attached image from this chat.
<img width="1470" height="956" alt="Screenshot 2026-06-26 at 18 02 03" src="https://github.com/user-attachments/assets/580efd0e-4be7-4493-a13c-fe4f6e7b8ad8" />

