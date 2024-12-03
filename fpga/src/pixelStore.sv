module pixelStore (input  logic clk, reset,
                   input  logic brush,
                   input  logic [2:0] newColor,
                   input  logic [7:0] wx, wy,
                   input  logic [9:0] rx, ry,
                   output logic [2:0] colorCode);

  logic [2:0] colorCodeRam; //
  // logic [2:0] colorArray [40000:0];


  // always_ff @(posedge clk) begin
  //   if(brush) colorArray[] <= newColor;
  //   colorCodeRam <= colorArray[{ry[7:0],rx[7:0]}];
  // end

  always_comb begin
    if ($unsigned(rx) >= 200 || $unsigned(ry) >= 200) begin
      colorCode = 3'b101;
    end else begin
      colorCode = colorCodeRam;
    end
  end
  
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
    .rd_addr_i({ry[6:0],rx[7:0]}),
    .rd_data_o(colorCodeRam)); 
  
  
endmodule
