// Jordan Carlin (jcarlin@hmc.edu) and Zoe Worrall (zworrall@g.hmc.edu)
// December 2024
// VGA timing controller module

`include "vgaParameters.sv"

module vgaController (
  input  logic       clk, reset,
  output logic       hsync, vsync, blank_b,
  output logic [9:0] x, y
);

  logic vgaClk;

  // Clock divider logic (slow PLL clock to VGA pixel clock of 25.175 MHz)
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

  // force outputs to black when not writing pixels
  assign blank_b = (x < HACTIVE) & (y < VACTIVE);
endmodule
