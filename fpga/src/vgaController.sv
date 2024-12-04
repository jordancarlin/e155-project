`include "vgaParameters.svh"

module vgaController (
  input  logic       clk, reset,
  output logic       hsync, vsync, blank_b,
  output logic [9:0] x, y
);

  // counters for horizontal and vertical positions
  always_ff @(posedge clk, posedge reset) begin
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

  //  always_ff @(posedge clk) begin
  //   if (reset) begin
  //     x <= 0;
  //     y <= 0;
  //   end else if ($unsigned(x) == (HACTIVE + HFP)) begin
  //     x <= 0;
  //     y <= 0;
  //   end else begin
  //     x <= HACTIVE + HFP;
  //     y <= VACTIVE + VFP;
  //   end
  //  end

  // compute sync signals (active low)
  // active when between front and back porches only
  assign hsync = ~( (x >= (HACTIVE + HFP)) & (x < (HACTIVE + HFP + HSYN)) );
  assign vsync = ~( (y >= (VACTIVE + VFP)) & (y < (VACTIVE + VFP + VSYN)) );

  // assign sync_b = 1'b0; // this should be 0 for newer monitors

  // force outputs to black when not writing pixels
  assign blank_b = (x < HACTIVE) & (y < VACTIVE);
endmodule
