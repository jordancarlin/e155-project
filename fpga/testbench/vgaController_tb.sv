// generated using copilot

module vgaController_tb;

  // Testbench signals
  logic vgaclk;
  logic reset;
  logic hsync;
  logic vsync;
  logic [9:0] x;
  logic [9:0] y;

  // Instantiate the vgaController module
  vgaController dut (
    .vgaclk(vgaclk),
    .reset(reset),
    .hsync(hsync),
    .vsync(vsync),
    .x(x),
    .y(y)
  );

  // Clock generation
  initial begin
    vgaclk = 0;
    forever #5 vgaclk = ~vgaclk;
  end

  // Test sequence
  initial begin
    // Apply reset
    reset = 1;
    #20;
    reset = 0;

    // Run simulation for a specific period
    #1000;

    // Finish simulation
    $finish;
  end

  // Monitor signals
  initial begin
    $monitor("Time: %0t | hsync: %b | vsync: %b | x: %d | y: %d", $time, hsync, vsync, x, y);
  end

endmodule
