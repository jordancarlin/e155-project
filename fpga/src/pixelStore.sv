module pixelStore (input  logic clk,
                   input  logic brush, //ready,
                   input  logic [9:0] rx, ry, wx, wy,
                   input  logic [2:0] newColor,
                   output logic [2:0] colorCode);

  logic [2:0] colorArray [9:0][9:0];

  initial $readmemh("testcolor.mem", colorArray);

  always_ff @(posedge clk) begin
    if(brush) colorArray[wy[3:0]][wx[3:0]] <= newColor;
    colorCode <= colorArray[ry[3:0]][rx[3:0]];
  end
endmodule
