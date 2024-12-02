module colorDecode (input  logic       brush,
                    input  logic [2:0] colorCode,
                    output logic [3:0] r, g, b);

  localparam white = 3'b000;
  localparam red = 3'b001;
  localparam blue = 3'b010;
  localparam green = 3'b011;
  localparam yellow = 3'b100;
  localparam purple = 3'b101;
  localparam erase = 3'b111;

  localparam redRGB = {4'hFFF, 4'h000, 4'h000};
  localparam greenRGB = {4'h000, 4'hFFF, 4'h000};
  localparam blueRGB = {4'h000, 4'h000, 4'hFFF};
  localparam yellowRGB = {4'hFFF, 4'hFFF, 4'h000};
  localparam purpleRGB = {4'hFFF, 4'h000, 4'hFFF};
  localparam whiteRGB = {4'hFFF, 4'hFFF, 4'hFFF};
  localparam eraseRGB = {4'h000, 4'h000, 4'h000};
  localparam brushRGB = {4'hFFF, 4'hF80, 4'h000};

  // convert color to rgb values
  always_comb
    if(brush) {r, g, b} = brushRGB;
    else case(colorCode)
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
