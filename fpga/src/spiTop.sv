// Jordan Carlin (jcarlin@hmc.edu) and Zoe Worrall (zworrall@g.hmc.edu)
// December 2024
// SPI top-level module

module spiTop(input  logic       clk, reset, sck, sdi, cs,
              output logic       brushUpdate,
              output logic [7:0] x, y,
              output logic [2:0] newColorUpdate,
              output logic       updateConfig, updatePosition);

  logic [7:0] spiPacket1, spiPacket2;
  logic ready;
  logic sdiSync, sckSync, csSync;

  // synchronize inputs from MCU
  synchronizer sck_sync(.clk(clk), .reset(reset), .async_signal(sck), .sync_signal(sckSync));
  synchronizer sdi_sync(.clk(clk), .reset(reset), .async_signal(sdi), .sync_signal(sdiSync));
  synchronizer cs_sync(.clk(clk), .reset(reset), .async_signal(cs),  .sync_signal(csSync));

  // instantiate SPI modules
  spi spi(.sck(sckSync), .sdi(sdiSync), .cs(csSync), .spiPacket1(spiPacket1), .spiPacket2(spiPacket2));
  spiFSM spiFSM(.clk(clk), .reset(reset), .cs(csSync), .ready(ready));
  spiDecode spiDecode(.ready(ready), .spiPacket1(spiPacket1), .spiPacket2(spiPacket2), .updateConfig(updateConfig), .updatePosition(updatePosition), .brush(brushUpdate), .x(x), .y(y), .newColor(newColorUpdate));

endmodule
