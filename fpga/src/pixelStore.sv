module pixelStore (input  logic clk,
                   input  logic brush, //ready,
                   input  logic [9:0] rx, ry,
                   input  logic [7:0] wx, wy,
                   input  logic [2:0] newColor,
                   output logic [2:0] colorCode);

  logic [2:0] colorArray [200:0][200:0];

  initial $readmemb("testcolor.mem", colorArray);

  always_ff @(posedge clk) begin
    if(brush) colorArray[wy][wx] <= newColor;
    colorCode <= colorArray[ry[7:0]][rx[7:0]];
  end
endmodule
