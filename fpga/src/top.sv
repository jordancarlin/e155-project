`include "colors.sv"
module top(input  logic       clk_hf, reset,
           input  logic       sck, sdi, cs, // SPI from MCU
           output logic       hsync, vsync, // to VGA monitor
           output logic       test,
           output logic [3:0] rBlanked, gBlanked, bBlanked); // to video DAC


  logic clk;
  logic [7:0] x, y, curX, curY;
  logic [9:0] vgaX, vgaY;
  logic [3:0] r, g, b;
  logic blank_b;
  logic brush, brushUpdate;
  logic [2:0] colorCode, newColor, newColorUpdate;
  logic updateConfig, updatePosition;

  // logic [7:0] x2, y2;
  // assign x2 = 'b0;
  // assign y2 = 'b0;

  // assign test = ready;

  spiTop spiTop(.clk(clk), .reset(reset), .sck(sck), .sdi(sdi), .cs(cs), .brushUpdate(brushUpdate), .x(x), .y(y), .newColorUpdate(newColorUpdate), .updateConfig(updateConfig), .updatePosition(updatePosition), .test(test));

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


  // Use a PLL to create the 25.175 MHz VGA pixel clock
  // 25.175 MHz clk period = 39.772 ns
  // Screen is 800 clocks wide by 525 tall, but only 640 x 480 used
  // HSync = 1/(39.772 ns *800) = 31.470 kHz
  // Vsync = 31.474 kHz / 525 = 59.94 Hz (~60 Hz refresh rate)
  /* verilator lint_off PINCONNECTEMPTY */
  syspll syspll(.ref_clk_i(clk_hf), .rst_n_i(~reset), .outcore_o(clk), .outglobal_o());
  /* verilator lint_on PINCONNECTEMPTY */

  vgaController vgaController(.clk(clk), .reset(reset), .hsync(hsync), .vsync(vsync), .blank_b(blank_b), .x(vgaX), .y(vgaY));

  pixelStore pixelStore(.clk(clk), .reset(reset), .brush(brush), .rx(vgaX), .ry(vgaY), .wx(curX), .wy(curY), .colorCode(colorCode), .newColor(newColor));
  colorDecode colorDecode(.brush(brush), .colorCode(colorCode), .vgaX(vgaX[7:0]), .vgaY(vgaY[7:0]), .curX(curX), .curY(curY), .r(r), .g(g), .b(b));

  assign rBlanked = r ;//& {4{blank_b}};
  assign gBlanked = g ;//& {4{blank_b}};
  assign bBlanked = b ;//& {4{blank_b}};
endmodule
