module pixelStore (input clk,
                   input [9:0] x, y,
                   input [2:0] newColor,
                   output [2:0] color);
  logic [9:0] colorArray [9:0]

  always_ff @(posedge clk)
    color <= colorArray[y][x];
endmodule
