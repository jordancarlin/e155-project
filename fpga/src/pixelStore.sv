// Jordan Carlin (jcarlin@hmc.edu) and Zoe Worrall (zworrall@g.hmc.edu)
// December 2024
// Store pixel color data in SPRAM and read it back for VGA display

`include "vgaParameters.sv"
`include "colors.sv"

module pixelStore (input  logic clk, reset,
                   input  logic brush,
                   input  logic [2:0] newColor,
                   input  logic [7:0] wx, wy,
                   input  logic [9:0] rx, ry,
                   output logic [2:0] colorCode);

  logic [9:0] rxRam, ryRam;
  logic [2:0] colorCodeRam, testColor;
  logic [15:0] ramDataFlopped;
  logic [13:0] resetCount;
  logic [13:0] ramAdr;
  logic ramWE;
  logic [15:0] ramWriteData, ramData;

  // Set color to value in RAM if within valid bounds, otherwise use predefined color
  always_comb begin
    rxRam = rx;
    ryRam = ry;
    if (ry > 128 | rx > 128)
      colorCode = outside;
    else
      colorCode = colorCodeRam;
  end

  // SPRAM FSM controller
  // Alternate between reading and writing from the SPRAM
  // Begin by zeroing out the RAM on boot
  typedef enum logic [1:0] { RAM_SETUP, RAM_READ, RAM_WRITE } RAM_STATE;
  RAM_STATE ramState, ramNextState;

  // FSM state
  always_ff @( posedge clk ) begin
    if (reset) begin
      ramState <= RAM_SETUP;
      resetCount <= '0;
    end else begin
      ramState <= ramNextState;
      resetCount <= resetCount + 1'b1;
    end
  end

  // FSM next state logic
  always_comb begin
    if (reset) begin
      ramNextState = RAM_SETUP;
    end else begin
      case(ramState)
        RAM_SETUP: begin
                    if ($unsigned(resetCount) == 14'd16383) ramNextState = RAM_READ;
                    else ramNextState = RAM_SETUP;
                  end
        RAM_READ: ramNextState = RAM_WRITE;
        RAM_WRITE: ramNextState = RAM_READ;
        default: ramNextState = RAM_READ;
      endcase
    end
  end

  // SPRAM address and data logic (FSM output logic)
  always_comb begin
    case(ramState)
      RAM_SETUP: begin
                   ramAdr = resetCount;
                   ramWE = 1'b1;
                   ramWriteData = 0;
                 end
      RAM_READ: begin
                  ramAdr = {ryRam[6:0], rxRam[6:0]};
                  ramWE = 0;
                  ramWriteData = 0;
                end
      RAM_WRITE: begin
                  ramAdr = {wy[6:0], wx[6:0]};
                  ramWE = brush;
                  ramWriteData = {13'b0,newColor};
                end
    endcase
  end

  // SPRAM module instantiation
  SP256K spramPixelArray(
  .DI(ramWriteData),
  .AD(ramAdr),
  .MASKWE(4'b1111),
  .WE(ramWE),
  .CS(1'b1),
  .CK(clk),
  .STDBY(1'b0),
  .SLEEP(1'b0),
  .PWROFF_N(1'b1),
  .DO(ramData));

  // Hold the data from the SPRAM for timing reasons
  always_ff @(posedge clk)
    if (reset) ramDataFlopped <= '0;
    else ramDataFlopped <= ramData;

  assign colorCodeRam = ramDataFlopped[2:0];

endmodule
