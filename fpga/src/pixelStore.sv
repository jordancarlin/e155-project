module pixelStore (input  logic clk,
                   input  logic brush, //ready,
                   input  logic [7:0] rx, ry, wx, wy,
                   input  logic [2:0] newColor,
                   output logic [2:0] colorCode);

  logic [2:0] colorArray [7:0][7:0];

  initial $readmemb("testcolor.mem", colorArray);

  always_ff @(posedge clk) begin
    if(brush) colorArray[wy][wx] <= newColor;
    colorCode <= colorArray[ry][rx];
  end
endmodule
