module fpgaTop(input  logic       reset,
               input  logic       sck, sdi, cs, // SPI from MCU
               output logic       hsync, vsync, // to VGA monitor
               output logic       test,
               output logic [3:0] rBlanked, gBlanked, bBlanked); // to video DAC

  logic clk_hf;
  logic reset_n;
  assign reset_n = ~reset;

  // internal high speed oscillator
  HSOSC hf_osc(.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk_hf));

  top top(.reset(reset_n), .*);

endmodule

