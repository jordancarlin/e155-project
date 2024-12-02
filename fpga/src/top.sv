module top(input  logic       clk, reset,
          //  input  logic       sck, sdi,
          //  output logic       sdo,
          //  output logic       vgaclk, // 25.175 MHz VGA clock
           output logic       hsync, vsync,
          //  output logic       sync_b, blank_b, // to monitor & DAC
           output logic [3:0] r, g, b); // to video DAC

  logic vgaclk, sync_b, blank_b;
  logic [9:0] x, y, vgaX, vgaY;
  logic brush;
  logic [2:0] colorCode, newColor;
  logic [7:0] spiPacket;
  // logic ready;

  assign brush = 1;
  assign newColor = 3'b101;
  assign x = vgaX;
  assign y= vgaY;

  vga vga(.clk, .reset, .vgaclk, .hsync, .vsync, .vgaX, .vgaY); //, .r, .g, .b);
  pixelStore pixelStore(.clk(vgaclk), .brush, .rx(vgaX), .ry(vgaY), .wx(x), .wy(y), .colorCode, .newColor);
  colorDecode colorDecode(.brush, .colorCode, .r, .g, .b);
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
