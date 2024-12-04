module pixelStore (input  logic clk, reset,
                   input  logic brush,
                   input  logic [2:0] newColor,
                   input  logic [7:0] wx, wy,
                   input  logic [9:0] rx, ry,
                   output logic [2:0] colorCode);

  logic [9:0] rxRam, ryRam;

  // 640 * 480
  // 180 * 180
  // 360 * 360

  localparam MAX_COORDINATE = 180;

  logic [2:0] colorCodeRam; //
  // logic [2:0] colorArray [40000:0];


  // always_ff @(posedge clk) begin
  //   if(brush) colorArray[] <= newColor;
  //   colorCodeRam <= colorArray[{ry[7:0],rx[7:0]}];
  // end

  always_comb begin
    rxRam = rx - 10'd230;
    ryRam = ry - 10'd150;

    if (rxRam < 0 | ryRam < 0)
      colorCode = 3'b101;
    else if (rxRam >= MAX_COORDINATE | ryRam >= MAX_COORDINATE)
      colorCode = 3'b101;
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
