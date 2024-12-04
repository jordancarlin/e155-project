`include "vgaParameters.svh"
`include "colors.svh"

module pixelStore (input  logic clk, reset,
                   input  logic brush,
                   input  logic [2:0] newColor,
                   input  logic [7:0] wx, wy,
                   input  logic [9:0] rx, ry,
                   output logic [2:0] colorCode);

  logic [9:0] rxRam, ryRam;
  logic [2:0] colorCodeRam;

  always_comb begin
    rxRam = (rx - (HACTIVE - MAX_COORDINATE)/2) >> 1;
    ryRam = (ry - (VACTIVE - MAX_COORDINATE)/2) >> 1;

    if (rxRam < 0 | ryRam < 0)
      colorCode = purple;
    else if (rxRam >= MAX_COORDINATE | ryRam >= MAX_COORDINATE)
      colorCode = purple;
    else
      colorCode = colorCodeRam;
  end

    // if ($unsigned(rx) >= MAX_COORDINATE || $unsigned(ry) >= MAX_COORDINATE) begin
    //   colorCode = 3'b101;
    // end else begin
    //   colorCode = colorCodeRam;
    // end

  pixelRam pixelRam(
    .wr_clk_i(clk),
    .rd_clk_i(clk),
    .rst_i(reset),
    .wr_clk_en_i(1'b1),
    .rd_en_i(1'b1),
    .rd_clk_en_i(1'b1),
    .wr_en_i(brush),
    .wr_data_i(newColor),
    .wr_addr_i({wy[6:0],wx}),
    .rd_addr_i({ryRam[6:0],rxRam[7:0]}),
    .rd_data_o(colorCodeRam));
endmodule
