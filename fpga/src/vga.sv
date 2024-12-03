module vga(input  logic       clk, reset,
           output logic       hsync, vsync,
          //  output logic       sync_b, blank_b, // to monitor & DAC
           //  output logic [7:0] r, g, b // to video DAC
           output logic [9:0] vgaX, vgaY); // to pixelStore

  // generate monitor timing signals
  vgaController vgaController(.clk, .reset, .hsync, .vsync, .x(vgaX), .y(vgaY));
endmodule
