module spiTop(input  logic       clk, reset, sck, sdi, cs,
              output logic       brushUpdate,
              output logic [7:0] x, y,
              output logic [2:0] newColorUpdate,
              output logic       updateConfig, test);

  logic [7:0] spiPacket1, spiPacket2;
  logic ready;
  logic sdiSync, sckSync, csSync;

  // , .test(test)

  // synchronize inputs from MCU
  synchronizer sck_sync(.clk(clk), .reset(reset), .async_signal(sck), .sync_signal(sckSync));
  synchronizer sdi_sync(.clk(clk), .reset(reset), .async_signal(sdi), .sync_signal(sdiSync));
  synchronizer cs_sync(.clk(clk), .reset(reset), .async_signal(cs),  .sync_signal(csSync));

  spi spi(.sck(sckSync), .sdi(sdiSync), .cs(csSync), .spiPacket1(spiPacket1), .spiPacket2(spiPacket2));
  spiFSM spiFSM(.clk(clk), .reset(reset), .cs(csSync), .ready(ready));
  spiDecode spiDecode(.ready(ready), .spiPacket1(spiPacket1), .spiPacket2(spiPacket2), .updateConfig(updateConfig), .brush(brushUpdate), .x(x), .y(y), .newColor(newColorUpdate));


  logic holdTest;
  logic [31:0] counter;
  always_ff @(posedge clk)
    if (reset) begin
      holdTest <= 1'b0;
      counter <= '0;
    end else if (x[0]) begin
      holdTest <= 1'b1;
      counter <= 1;
    end else if (counter > 30) begin
      holdTest <= '0;
      counter <= '0;
    end else if (holdTest) begin
      holdTest <= '1;
      counter <= counter + 1;
    end else begin
      holdTest <= '0;
      counter <= 0;
    end

  assign test = (holdTest);


endmodule
