module pixelStore_tb;

  logic clk, reset, brush;
  logic [2:0] newColor;
  logic [7:0] wx, wy;
  logic [9:0] rx, ry;
  logic [2:0] colorCode;

  // Instantiate the pixelStore module
  pixelStore dut (
    .clk(clk),
    .reset(reset),
    .brush(brush),
    .newColor(newColor),
    .wx(wx),
    .wy(wy),
    .rx(rx),
    .ry(ry),
    .colorCode(colorCode)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test sequence
  initial begin
    // Initialize inputs
    reset = 1;
    brush = 0;
    newColor = 3'b000;
    wx = 8'd0;
    wy = 8'd0;
    rx = 10'd0;
    ry = 10'd0;

    // Apply reset
    #10 reset = 0;

    // Test case 1: Read from an address, write to that address, and then read from it again
    #10 rx = 10'd300; ry = 10'd300;
    #10 brush = 1; newColor = 3'b100; wx = 8'd300; wy = 8'd300;
    #50 brush = 0; rx = 10'd300; ry = 10'd300;

    // Test case 2: Read from an out-of-bounds coordinate
    #100 rx = 10'd600; ry = 10'd400;

    // Test case 3: Read from an address before writing another color
    #10 rx = 10'd40; ry = 10'd40;
    #10 brush = 1; newColor = 3'b011; wx = 8'd20; wy = 8'd20;
    #10 brush = 0;

  end

  // Monitor signals
  initial begin
    $monitor("Time=%0t, reset=%b, brush=%b, newColor=%b, wx=%d, wy=%d, rx=%d, ry=%d, colorCode=%b",
             $time, reset, brush, newColor, wx, wy, rx, ry, colorCode);
  end

endmodule