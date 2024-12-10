# Jordan and Zoe HMC E155 Final Project

This repostitory contains all relevant files to the Micro P(ictionary) project made by Jordan and Zoe for ENGR 155, MicroProcessors at Harvey Mudd College.

For full details on the project, see the [website](https://jordancarlin.github.io/e155-project/).

## Repository Structure

There are three primary directories that are important to this project:

### `mcu`

Contains all of the necessary code for the MCU, including headers, C code, and the main function.

* `lib`: Contains all files relevant to specifically the STM32L432KC* board used for this project, as well as the header file for our main function. Defines functions, pins, and any other necessary pieces of code that are used in our main function.

* `segger_project`: Where the actual RDF file for the project resides, as well as many of the default components necessary for a Segger Project.

* `src`: Only contains the main.c function. If a user wanted to add more C files in the future that take advantage of the files in lib, they would go here.



### `FPGA`

All of the relevant files for the FPGA board, including ways to test the FPGA, the code to run off of the FPGA, etc.

* `radiant_project`
  * A list of .mem files to preload block RAM with for testing.
  * `pins.pds` constraint file that links the inputs and outputs of the FPGA to specific pins on the board.
  * Various other files that are necessary for Lattice Radiant to run the project and properly synthesize the Verilog.

* `sim`: Files needed to run simulations using the testbences in ModelSim/Questa.

* `src`: All SystemVerilog code for the FPGA. This includes the top-level modules `fpgaTop` and `top` as well as all of the more specific SPI and VGA modules that are used in the project.


* `testbench`: All SystemVerilog testbenches for the various modules in the `src` directory.

### `website`

A folder containing all of the parts of our website. Everything on the [webpage](/https://jordancarlin.github.io/e155-project), especially the code or styling, can be found this directory.
