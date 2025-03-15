# MIPS Processor Implementation in Verilog

This repository contains a Verilog implementation of a MIPS processor, developed as part of a computer organization project. The design encompasses essential components of a MIPS architecture, providing a foundational framework for understanding processor design and functionality.

## Overview

The MIPS processor is a classic example of a Reduced Instruction Set Computer (RISC) architecture, widely used in both academic and industry settings due to its simplicity and efficiency. This project aims to implement a single-cycle MIPS processor, where each instruction is executed in one clock cycle, facilitating a straightforward understanding of processor operations.

## Features

- **Single-Cycle Execution:** Each instruction completes in a single clock cycle, simplifying the control logic and providing clear insights into the instruction flow.

- **Core Components:**
  - **Program Counter (PC):** Maintains the address of the next instruction to be executed.
  - **Instruction Memory:** Stores the set of instructions (program) to be executed by the processor.
  - **Register File:** Contains the set of registers used for operand storage and operations.
  - **Arithmetic Logic Unit (ALU):** Performs arithmetic and logical operations as dictated by the instruction set.
  - **Data Memory:** Holds data that is read from or written to during program execution.
  - **Control Unit:** Generates control signals based on the current instruction to coordinate the operations of other components.

## File Structure

- **`PC.v`**: Implements the Program Counter module.
- **`InstructionMemory.v`**: Defines the instruction memory module.
- **`RegFile.v`**: Contains the register file implementation.
- **`MIPS_ALU.v`**: Implements the Arithmetic Logic Unit.
- **`DataMemory.v`**: Defines the data memory module.
- **`control.v`**: Implements the control unit logic.
- **`AluCtl.v`**: Contains the ALU control logic.
- **`integration.v`**: Integrates all modules to form the complete processor.
- **`clock_generator.v`**: Generates the clock signal for synchronization.
- **`VariousModules.v`**: Includes additional supporting modules.

## Getting Started

To simulate and test this MIPS processor implementation:

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/AhmadAbdElHakim/MIPS.git
   ```
2. **Navigate to the Directory:**
   ```bash
   cd MIPS
   ```
3. **Compile and Simulate:**
   - Use a Verilog simulation tool (such as ModelSim or Icarus Verilog) to compile and run the testbenches provided.
   - Ensure that all module dependencies are included during compilation.

## Contributions

Contributions to enhance this project are welcome. Please adhere to the following guidelines:

- **Modular Development:** Commit new modules in separate files without modifying existing work by others.
- **File Naming:** Avoid using personal names for file naming; use descriptive names relevant to the module's functionality.

## Acknowledgments

This project is a collaborative effort aimed at deepening the understanding of processor design using Verilog. It serves as an educational tool for those interested in computer architecture and hardware description languages.

For more detailed information on MIPS processor design and Verilog implementations, consider referring to resources such as:

- [Verilog code for 16-bit single cycle MIPS processor](https://www.fpga4student.com/2017/01/verilog-code-for-single-cycle-MIPS-processor.html)
- [Building a MIPS single-cycle processor in Verilog](https://medium.com/@LambdaMamba/building-a-mips-single-cycle-processor-in-verilog-9a3fac6321d)

These resources provide additional insights and examples that complement the understanding of this project. 
