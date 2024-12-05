`include "vgaParameters.sv"
`include "colors.sv"

module colorDecode (input  logic       brush,
                    input  logic [2:0] colorCode,
                    input  logic [7:0] vgaX, vgaY, curX, curY,
                    output logic [3:0] r, g, b);

  // convert color to rgb values
  always_comb
    if (colorCode == outside) {r, g, b} = outsideRGB;
    else if(vgaX == curX & vgaY == curY) {r, g, b} = brushRGB;
    else
    case(colorCode)
      red:     {r, g, b} = redRGB;
      green:   {r, g, b} = greenRGB;
      blue:    {r, g, b} = blueRGB;
      yellow:  {r, g, b} = yellowRGB;
      purple:  {r, g, b} = purpleRGB;
      white:   {r, g, b} = whiteRGB;
      erase:   {r, g, b} = eraseRGB;
      default: {r, g, b} = brushRGB;
    endcase
endmodule
