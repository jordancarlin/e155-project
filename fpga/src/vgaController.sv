module vgaController #(parameter HBP = 10'd48, // horizontal back porch
                      HACTIVE = 10'd640, // number of pixels per line
                      HFP = 10'd16, // horizontal front porch
                      HSYN = 10'd96, // horizontal sync pulse = 60 to move electron gun back to left
                      HMAX = HBP + HACTIVE + HFP + HSYN, //48+640+16+96=800: number of horizontal pixels
                      VBP = 10'd32, // vertical back porch
                      VACTIVE = 10'd480, // number of lines
                      VFP = 10'd11, // vertical front porch
                      VSYN = 10'd2, // vertical sync pulse = 2 to move electron gun back to top
                      VMAX = VBP + VACTIVE + VFP + VSYN) //32+480+11+2=525: number of vertical pixels
  (input  logic       vgaclk, reset,
   output logic       hsync, vsync, sync_b, blank_b,
   output logic [7:0] x, y);

  // counters for horizontal and vertical positions
  /* verilator lint_off BLKSEQ */
  always @(posedge vgaclk, posedge reset) begin
    if (reset) begin
      x = 0;
      y = 0;
    end else begin
      x++;
      if (x == HMAX) begin
        x = 0;
        y++; // increment vertical when get to end on line (x at HMAX)
        if (y == VMAX)
          y = 0;
      end
    end
  end
  /* verilator lint_on BLKSEQ */

  // compute sync signals (active low)
  // active when between front and back porches only
  assign hsync = ~( (x >= (HACTIVE + HFP)) & (x < (HACTIVE + HFP + HSYN)) );
  assign vsync = ~( (y >= (VACTIVE + VFP)) & (y < (VACTIVE + VFP + VSYN)) );
  // assign sync_b = hsync & vsync;
  assign sync_b = 1'b0; // this should be 0 for newer monitors

  // force outputs to black when not writing pixels
  assign blank_b = (x < HACTIVE) & (y < VACTIVE);
endmodule
