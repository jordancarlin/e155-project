module top(input  logic       clk_hf, reset,
           input  logic       sck, sdi, cs
           output logic       clk, // 25.175 MHz VGA clock
           output logic       hsync, vsync,
           output logic       blank_b, test,// to monitor & DAC
           output logic [3:0] rBlanked, gBlanked, bBlanked); // to video DAC

  logic [7:0] x, y;
  logic [9:0] vgaX, vgaY;
  logic [3:0] r, g, b;
  // logic blank_b;
  logic brush;
  logic [2:0] colorCode, newColor;
  logic [7:0] spiPacket;
  // logic ready;

  assign brush = 0;
  assign test = 0;
  assign newColor = 3'b101;
  assign x = vgaX[7:0];
  assign y= vgaY[7:0];

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

  // assign r = 4'hF;
  // assign b = 4'h0;
  // assign g = 4'hF;

  // logic [1:0] count;
  // always_ff @ (posedge clk) begin
  //   test <= '0;
  //   if (reset) count <= '0;
  //   else begin
  //     if ($unsigned(count) == 0) {r, g, b} <= 12'hF00;
  //     else if ($unsigned(count) == 1) {r, g, b} <= 12'h0F0;
  //     else if ($unsigned(count) == 2) {r, g, b} <= 12'h00F;
  //     else begin
  //       {r, g, b} <= 12'hF0F;
  //       count <= '0;
  //       test <= 1'b1;
  //     end
  //     count <= count + 1'b1;
  //   end
  // end

  // always_ff @ (posedge clk) begin
  //   if (reset) {r, g, b} = 12'hF00;
  //   else begin
  //     if (r == 4'hF) {r, g, b} = 12'h0F0;
  //     else {r, g, b} = 12'hF00;
  //   end
  // end

  // spiDecode spiDecode(.clk, .spiPacket, .brush, .newColor, .x, .y, .ready); // should this use sck as clock?
  // spi spi(.sck, .sdi, .sdo, .spiPacket);

  // spi spi(.spi2_miso_io(sdo),
  //   .spi2_mosi_io(sdi),
  //   .spi2_sck_io(sck),
  //   .spi2_scs_n_i(cs),
  //   .rst_i(reset),
  //   // .ipload_i( ),
  //   // .ipdone_o( ),
  //   .sb_clk_i(clk),
  //   // .sb_wr_i(),
  //   // .sb_stb_i( ),
  //   // .sb_adr_i( ),
  //   // .sb_dat_i( ),
  //   .sb_dat_o(spiPacket)
  //   // .sb_ack_o( ),
  //   // .spi_pirq_o( ),
  //   // .spi_pwkup_o( )
  //   );

  assign rBlanked = r & {4{blank_b}};
  assign gBlanked = g & {4{blank_b}};
  assign bBlanked = b & {4{blank_b}};
endmodule
