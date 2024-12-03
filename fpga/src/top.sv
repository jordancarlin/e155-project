module top(input  logic       clk_hf, reset,
           input  logic       sck, sdi, cs, // SPI from MCU
           output logic       hsync, vsync, // to VGA monitor
           output logic       test,
           output logic [3:0] rBlanked, gBlanked, bBlanked); // to video DAC

  assign test = 0;

  logic clk;
  logic [7:0] x, y;
  logic [9:0] vgaX, vgaY;
  logic [3:0] r, g, b;
  logic blank_b;
  logic brush, brushUpdate;
  logic [2:0] colorCode, newColor, newColorUpdate;
  logic [7:0] spiPacket1, spiPacket2;
  logic ready, updateConfig;

  logic sckSync, sdiSync, csSync;

  // synchronize inputs from MCU
  synchronizer sck_sync(.clk, .reset, .async_signal(sck), .sync_signal(sckSync));
  synchronizer sdi_sync(.clk, .reset, .async_signal(sdi), .sync_signal(sdiSync));
  synchronizer cs_sync(.clk, .reset, .async_signal(cs),  .sync_signal(csSync));

  spi spi(.sck(sckSync), .sdi(sdiSync), .cs(csSync), .spiPacket1, .spiPacket2);
  spiFSM spiFSM(.clk, .reset, .cs(csSync), .ready);
  spiDecode spiDecode(.ready, .spiPacket1, .spiPacket2, .updateConfig, .brush(brushUpdate), .x, .y, .newColor(newColorUpdate));

  // Save brush state and color
  always_ff @(posedge clk) begin
    if (updateConfig) begin
      brush <= brushUpdate;
      newColor <= newColorUpdate;
    end
  end


  // Use a PLL to create the 25.175 MHz VGA pixel clock
  // 25.175 MHz clk period = 39.772 ns
  // Screen is 800 clocks wide by 525 tall, but only 640 x 480 used
  // HSync = 1/(39.772 ns *800) = 31.470 kHz
  // Vsync = 31.474 kHz / 525 = 59.94 Hz (~60 Hz refresh rate)
  /* verilator lint_off PINCONNECTEMPTY */
  syspll syspll(.ref_clk_i(clk_hf), .rst_n_i(~reset), .outcore_o(clk), .outglobal_o());
  /* verilator lint_on PINCONNECTEMPTY */

  vgaController vgaController(.clk, .reset, .hsync, .vsync, .blank_b, .x(vgaX), .y(vgaY));

  pixelStore pixelStore(.clk, .brush, .rx(vgaX), .ry(vgaY), .wx(x), .wy(y), .colorCode, .newColor);
  colorDecode colorDecode(.brush, .colorCode, .r, .g, .b);

  assign rBlanked = r & {4{blank_b}};
  assign gBlanked = g & {4{blank_b}};
  assign bBlanked = b & {4{blank_b}};
endmodule
