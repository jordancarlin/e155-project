module fpgaTop(input  logic       reset,
               input  logic       sck, sdi,
               output logic       sdo,
               output logic       vgaclk, // 25.175 MHz VGA clock
               output logic       hsync, vsync,
               output logic       sync_b, blank_b, // to monitor & DAC
               output logic [7:0] r, g, b); // to video DAC

  logic clk;

  // internal high speed oscillator
  HSOSC hf_osc(.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));

  top top(.*);

endmodule

