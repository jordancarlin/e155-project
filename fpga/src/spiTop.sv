module spiTop(input  logic       clk, reset, sck, sdi, cs,
              output logic       brushUpdate, ready,
              output logic [7:0] x, y,
              output logic [2:0] newColorUpdate,
              output logic       updateConfig);

  logic [7:0] spiPacket1, spiPacket2;
  // logic ready;
  logic sckSync, sdiSync, csSync;

  // synchronize inputs from MCU
  synchronizer sck_sync(.clk, .reset, .async_signal(sck), .sync_signal(sckSync));
  synchronizer sdi_sync(.clk, .reset, .async_signal(sdi), .sync_signal(sdiSync));
  synchronizer cs_sync(.clk, .reset, .async_signal(cs),  .sync_signal(csSync));

  spi spi(.sck(sckSync), .sdi(sdiSync), .cs(csSync), .spiPacket1(spiPacket1), .spiPacket2(spiPacket2));
  spiFSM spiFSM(.clk, .reset, .cs(csSync), .ready(ready));
  spiDecode spiDecode(.ready, .spiPacket1, .spiPacket2, .updateConfig, .brush(brushUpdate), .x, .y, .newColor(newColorUpdate));
endmodule
