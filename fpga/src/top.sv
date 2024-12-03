module top(input  logic       clk_hf, reset,
          //  input  logic       sck, sdi,
          //  output logic       sdo,
           output logic       clk, // 25.175 MHz VGA clock
           output logic       hsync, vsync,
          //  output logic       sync_b, blank_b, // to monitor & DAC
           output logic [3:0] rBlanked, gBlanked, bBlanked); // to video DAC

  logic [9:0] x, y, vgaX, vgaY;
  logic [3:0] r, g, b;
  logic blank_b;
  logic brush;
  logic [2:0] colorCode, newColor;
  logic [7:0] spiPacket;
  // logic ready;

  assign brush = 1;
  assign newColor = 3'b101;
  assign x = vgaX;
  assign y= vgaY;

  // Use a PLL to create the 25.175 MHz VGA pixel clock
  // 25.175 MHz clk period = 39.772 ns
  // Screen is 800 clocks wide by 525 tall, but only 640 x 480 used
  // HSync = 1/(39.772 ns *800) = 31.470 kHz
  // Vsync = 31.474 kHz / 525 = 59.94 Hz (~60 Hz refresh rate)
  syspll syspll(.ref_clk_i(clk_hf), .rst_n_i(~reset), .outcore_o(clk), .outglobal_o());

  vgaController vgaController(.clk, .reset, .hsync, .vsync, .blank_b, .x(vgaX), .y(vgaY));

  pixelStore pixelStore(.clk, .brush, .rx(vgaX), .ry(vgaY), .wx(x), .wy(y), .colorCode, .newColor);
  //colorDecode colorDecode(.brush, .colorCode, .r, .g, .b);

  assign r = 4'h0;
  assign b = 4'hF;
  assign g = 4'h0;

  assign rBlanked = r & ~{4{blank_b}};
  assign gBlanked = g & ~{4{blank_b}};
  assign bBlanked = b & ~{4{blank_b}};

  // colorDecode colorDecode(.brush, .colorCode, .r, .g, .b);
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


endmodule
