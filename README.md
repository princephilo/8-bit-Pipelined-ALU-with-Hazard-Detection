# 8-bit Pipelined ALU with Hazard Detection

A from-scratch Verilog implementation of an 8-bit ALU, built up step by step into a 3-stage
pipelined datapath, used as a learning project for RTL design fundamentals: combinational
logic, sequential logic, pipelining, and data hazards.

## Project Status

| Stage | Status |
|---|---|
| Combinational ALU core (ADD/SUB/AND/OR/XOR) | ✅ Done |
| Register file (8 × 8-bit, sync write / async read) | ✅ Done |
| Single-cycle datapath (ALU + regfile combined) | ✅ Done |
| 3-stage pipelined datapath (Decode → Execute → Writeback) | ✅ Done |
| RAW hazard demonstrated (back-to-back dependent instructions) | ✅ Done |
| Forwarding logic to fix the hazard | 🚧 In progress |
| Self-checking testbench (full instruction stream, pass/fail) | ⬜ Not started |
| Waveform debugging walkthrough (Surfer/GTKWave) | ⬜ Not started |

## Architecture

**Pipeline stages:**
```
D (Decode)              E (Execute)              W (Writeback)
───────────────         ──────────────────        ──────────────────
Read operand_a,         ALU computes result        Result written
operand_b from           from operands               back into regfile
regfile
```

**ALU operations supported:** ADD, SUB, AND, OR, XOR (3-bit opcode, 8-bit operands).

**Known issue (by design, not yet fixed):** the pipeline currently has an unresolved
**RAW (Read-After-Write) hazard**. If one instruction writes a register and the very next
instruction reads that same register, the read happens *before* the write has landed,
producing an incorrect (stale/garbage) result. This was deliberately demonstrated in
`hazard_tb.v` to motivate the forwarding logic — see "Known Limitations" below.

## Files

| File | Purpose |
|---|---|
| `alu.v` | Combinational 8-bit ALU — ADD, SUB, AND, OR, XOR |
| `alu_tb.v` | Standalone testbench for the ALU |
| `regfile.v` | 8×8-bit register file, synchronous write / asynchronous read |
| `regfile_tb.v` | Standalone testbench for the register file |
| `datapath.v` | Single-cycle datapath (ALU + regfile wired together, no pipelining) |
| `datapath_tb.v` | Testbench for the single-cycle datapath |
| `pipelined_datapath.v` | 3-stage pipelined datapath (D → E → W) |
| `pipelined_datapath_tb.v` | Testbench proving correct pipelined operation (with cycle gaps between instructions) |
| `hazard_tb.v` | Testbench that deliberately issues back-to-back dependent instructions to expose the RAW hazard |

## Simulation (Icarus Verilog)

Each module has its own testbench; compile the relevant module(s) together with its testbench.

**ALU only:**
```bash
iverilog -o alu_sim alu.v alu_tb.v
vvp alu_sim
```

**Register file only:**
```bash
iverilog -o regfile_sim regfile.v regfile_tb.v
vvp regfile_sim
```

**Single-cycle datapath:**
```bash
iverilog -o datapath_sim alu.v regfile.v datapath.v datapath_tb.v
vvp datapath_sim
```

**Pipelined datapath (correct operation, spaced-out instructions):**
```bash
iverilog -o pipe_sim alu.v regfile.v pipelined_datapath.v pipelined_datapath_tb.v
vvp pipe_sim
```

**Hazard demonstration (back-to-back dependent instructions — currently fails):**
```bash
iverilog -o hazard_sim alu.v regfile.v pipelined_datapath.v hazard_tb.v
vvp hazard_sim
```

## Known Limitations

- **No forwarding/hazard detection yet.** Two back-to-back instructions where the second
  reads a register the first one writes will produce an incorrect result. This is the
  next piece of work (see Project Status above).
- **No stalling mechanism.** Once forwarding is added, any hazard case forwarding can't
  cover (if any) would need a stall, which isn't implemented.
- **No real instruction memory / instruction stream.** Operations are currently driven
  directly by testbench signals rather than fetched from an instruction sequence.

## Toolchain

- **Simulator:** Icarus Verilog 13.0
- **Waveform viewer:** Surfer
- **Editor:** VS Code

---

*This project is being built incrementally as a guided learning exercise in RTL design —
each stage is verified working before moving to the next.*
<img width="1470" height="956" alt="Screenshot 2026-06-26 at 18 02 03" src="https://github.com/user-attachments/assets/580efd0e-4be7-4493-a13c-fe4f6e7b8ad8" />

