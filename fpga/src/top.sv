// Jordan Carlin (jcarlin@hmc.edu) and Zoe Worrall (zworrall@g.hmc.edu)
// December 2024
// Top-level module for the FPGA Pictionary game

`include "colors.sv"
module top(input  logic       clk_hf, reset,
           input  logic       sck, sdi, cs, // SPI from MCU
           output logic       hsync, vsync, // to VGA monitor
           output logic [3:0] rBlanked, gBlanked, bBlanked); // to video DAC

  logic clk;
  logic [7:0] x, y, curX, curY;
  logic [9:0] vgaX, vgaY;
  logic [3:0] r, g, b;
  logic blank_b;
  logic brush, brushUpdate;
  logic [2:0] colorCode, newColor, newColorUpdate;
  logic updateConfig, updatePosition;

  // Receive and decode SPI packets from MCU
  spiTop spiTop(.clk(clk), .reset(reset), .sck(sck), .sdi(sdi), .cs(cs), .brushUpdate(brushUpdate), .x(x), .y(y), .newColorUpdate(newColorUpdate), .updateConfig(updateConfig), .updatePosition(updatePosition));

  // Save brush state and color
  always_ff @(posedge clk) begin
    if (reset) begin
      brush <= brushUpdate;
      newColor <= newColorUpdate;
    end else if (updateConfig) begin
      brush <= brushUpdate;
      newColor <= newColorUpdate;
    end
  end

  // Save current position
  always_ff @(posedge clk) begin
    if (reset) begin
      curX <= '0;
      curY <= '0;
    end else if (updatePosition) begin
      curX <= x;
      curY <= y;
    end
  end

  // PLL to generate 50.35 MHz clock for SPRAM and VGA
  syspll syspll(.ref_clk_i(clk_hf), .rst_n_i(~reset), .outcore_o(clk), .outglobal_o());

  // VGA timing controller
  vgaController vgaController(.clk(clk), .reset(reset), .hsync(hsync), .vsync(vsync), .blank_b(blank_b), .x(vgaX), .y(vgaY));

  // Pixels to display on VGA
  pixelStore pixelStore(.clk(clk), .reset(reset), .brush(brush), .rx(vgaX), .ry(vgaY), .wx(curX), .wy(curY), .colorCode(colorCode), .newColor(newColor));
  colorDecode colorDecode(.brush(brush), .colorCode(colorCode), .vgaX(vgaX[7:0]), .vgaY(vgaY[7:0]), .curX(curX), .curY(curY), .r(r), .g(g), .b(b));

  // output colors to VGA DAC
  assign rBlanked = r ;
  assign gBlanked = g ;
  assign bBlanked = b ;
endmodule
