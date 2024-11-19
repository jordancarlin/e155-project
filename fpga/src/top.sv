module top(input  logic       clk, reset,
           output logic       vgaclk, // 25.175 MHz VGA clock
           output logic       hsync, vsync,
           output logic       sync_b, blank_b, // to monitor & DAC
           output logic [7:0] r, g, b); // to video DAC

  logic [9:0] x, y, vgaX, vgaY;
  logic brush;
  logic [2:0] colorCode, newColor;

  vga vga(.clk, .reset, .vgaclk, .hsync, .vsync, .sync_b, .blank_b, .vgaX, .vgaY); //, .r, .g, .b);
  pixelStore pixelStore(.clk, .brush, .rx(vgaX), .ry(vgaY), .wx(x), .wy(y), .colorCode, .newColor(0));
  colorDecode colorDecode(.brush, .colorCode, .r, .g, .b);
  spi spi(.brush, .newColor, .x, .y)

endmodule
