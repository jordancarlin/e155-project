module vga(input  logic       clk, reset,
           output logic       vgaclk, // 25.175 MHz VGA clock
           output logic       hsync, vsync,
          //  output logic       sync_b, blank_b, // to monitor & DAC
           //  output logic [7:0] r, g, b // to video DAC
           output logic [9:0] vgaX, vgaY); // to pixelStore

  // Use a PLL to create the 25.175 MHz VGA pixel clock
  // 25.175 MHz clk period = 39.772 ns
  // Screen is 800 clocks wide by 525 tall, but only 640 x 480 used
  // HSync = 1/(39.772 ns *800) = 31.470 kHz
  // Vsync = 31.474 kHz / 525 = 59.94 Hz (~60 Hz refresh rate)
  syspll syspll(.ref_clk_i(clk), .rst_n_i(reset), .outcore_o(vgaclk), .outglobal_o());

  // generate monitor timing signals
  vgaController vgaController(.vgaclk, .reset, .hsync, .vsync, .x(vgaX), .y(vgaY));
endmodule
