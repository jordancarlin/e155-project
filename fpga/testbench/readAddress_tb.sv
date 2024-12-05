module readAddress_tb;

  logic clk, reset, brush;
  logic [2:0] newColor;
  logic [7:0] wx, wy;
  logic [2:0] colorCode;
  logic hsync, vsync, blank_b;
  logic [9:0] vgaX, vgaY;

  // Instantiate the vgaController module
  vgaController vga_dut (
    .clk,
    .reset,
    .hsync,
    .vsync,
    .blank_b,
    .x(vgaX),
    .y(vgaY)
  );

  // Instantiate the pixelStore module
  pixelStore pixel_dut (
    .clk,
    .reset,
    .brush,
    .newColor,
    .wx,
    .wy,
    .rx(vgaX),
    .ry(vgaY),
    .colorCode
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

    // Apply reset
    #10 reset = 0;

    // Test case: Write to an address and check read address calculation
    #10 wx = 8'd100; wy = 8'd100; brush = 1; newColor = 3'b010;
    #10 brush = 0;

    // Wait for some time to let vgaController generate addresses
    #1000;

    // End simulation
    #100 $quit;
  end

  // Monitor signals
  initial begin
    $monitor("Time=%0t, reset=%b, brush=%b, newColor=%b, wx=%d, wy=%d, vgaX=%d, vgaY=%d, colorCode=%b, rx=%b ry=%b curly=%b",
             $time, reset, brush, newColor, wx, wy, vgaX, vgaY, colorCode, vgaX, vgaY, {vgaX,vgaY});
  end

endmodule