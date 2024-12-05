`include "vgaParameters.sv"

// 25.175 MHz clk period = 39.772 ns
// Screen is 800 clocks wide by 525 tall, but only 640 x 480 used
// HSync = 1/(39.772 ns *800) = 31.470 kHz
// Vsync = 31.474 kHz / 525 = 59.94 Hz (~60 Hz refresh rate)

module vgaController (
  input  logic       clk, reset,
  output logic       hsync, vsync, blank_b,
  output logic [9:0] x, y
);


  logic vgaClk;

  // Clock divider logic
  always_ff @(posedge clk)
    if (reset)
      vgaClk <= 1'b0;
    else
      vgaClk <= ~vgaClk;

  // counters for horizontal and vertical positions
  always_ff @(posedge vgaClk, posedge reset) begin
    if (reset) begin
      x <= '0;
      y <= '0;
    end else begin
      x <= x + 1'b1;
      if (x == HMAX) begin
        x <= '0;
        y <= y + 1'b1; // increment vertical when get to end on line (x at HMAX)
        if (y == VMAX)
          y <= '0;
      end
    end
  end

  // compute sync signals (active low)
  // active when between front and back porches only
  assign hsync = ~( (x >= (HACTIVE + HFP)) & (x < (HACTIVE + HFP + HSYN)) );
  assign vsync = ~( (y >= (VACTIVE + VFP)) & (y < (VACTIVE + VFP + VSYN)) );

  // assign sync_b = 1'b0; // this should be 0 for newer monitors

  // force outputs to black when not writing pixels
  assign blank_b = (x < HACTIVE) & (y < VACTIVE);
endmodule
