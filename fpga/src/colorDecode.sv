`include "vgaParameters.svh"
`include "colors.svh"

module colorDecode (input  logic       brush,
                    input  logic [2:0] colorCode,
                    output logic [3:0] r, g, b);

  // convert color to rgb values
  always_comb
    // if(brush) {r, g, b} = brushRGB;
    // else 
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
