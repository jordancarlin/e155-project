// generated using copilot

module vgaController_tb;

  // Testbench signals
  logic clk;
  logic reset;
  logic hsync;
  logic vsync;
  logic blank_b;
  logic [9:0] x;
  logic [9:0] y;

  // Instantiate the vgaController module
  vgaController dut (.*);

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test sequence
  initial begin
    // Apply reset
    reset = 1;
    #20;
    reset = 0;
  end

  // Monitor signals
  initial begin
    $monitor("Time: %0t | hsync: %b | vsync: %b | x: %d | y: %d", $time, hsync, vsync, x, y);
  end

endmodule
