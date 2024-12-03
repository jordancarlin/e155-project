module fpgaTop(input  logic       reset,
              //  input  logic       sck, sdi,
              //  output logic       sdo,
               output logic       clk, // 25.175 MHz VGA clock
               output logic       hsync, vsync,
               output logic       blank_b, // to monitor & DAC
               output logic [3:0] rBlanked, gBlanked, bBlanked); // to video DAC

  logic clk_hf;
  logic reset_n;
  assign reset_n = ~reset;

  // internal high speed oscillator
  HSOSC hf_osc(.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk_hf));

  top top(.reset(reset_n), .*);

endmodule

