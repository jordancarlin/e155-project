# Jordan and Zoe HMC E155 Final Project

This folder contains all relevant files to the Micro P(ictionary) project made by Jordan and Zoe for ENGR 155, MicroProcessors at Harvey Mudd College.

To access the website, please use [this link](https://jordancarlin.github.io/e155-project/)

## Repository Structure

There are three primary folders that are important to this Github folder.

### `mcu`

Contains all of the necessary code for the MCU, including headers, C code, and the main function.

* `lib`: Contains all files relevant to specifically the STM32L432KC* board currently being used, as well as the header file for our main function. Defines functions, pins, and any other necessary pieces of code that we'll need to use in our main function.

* `segger_project`: Where the actual RDF file for the project resides, as well as many of the parts of the MCU board that automatically generate with a new project.

* `src`: Only contains the main.c function. If a user wanted to add more C files in the future that take advantage of the files in lib, they would go here.



### `FPGA`

All of the relevant files for the FPGA board, including ways to test the FPGA, the code to run off of the FPGA, etc.

* `radiant_project`
> A list of .mem files. These files are loaded into the machine when it first starts up in order to add a background (if we are not using RAM). These are a byproduct of our testing phase for the VGA, and they are not necessary unless the user wants to start with a cool background loaded.\
> JORDAN IDK WHAT TO PUT HERE

* `sim`: The files necessary to export the code to the FPGA board and to save for the project. You will never open these, and will mainly interact with them through Applications like Lattice Radiant.

* `src`: All SystemVerilog code relevant to controlling the FPGA.

JORDAN WRITE AN EXPLANATION HERE

* `testing`: A folder containing all of the ModelSim test benches that we hav ebeen using.

### `website`

A folder containing all of the parts of our website. Everything on the [webpage](/https://jordancarlin.github.io/e155-project), especially the code or styling, can be found this directory.