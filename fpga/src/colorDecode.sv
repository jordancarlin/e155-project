module colorDecode (input  logic       brush,
                    input  logic [2:0] colorCode,
                    output logic [7:0] r, g, b);

  localparam white = 3'b000;
  localparam red = 3'b001;
  localparam blue = 3'b010;
  localparam green = 3'b011;
  localparam yellow = 3'b100;
  localparam purple = 3'b101;
  localparam erase = 3'b111;

  localparam redRGB = {8'd255, 8'd0, 8'd0};
  localparam greenRGB = {8'd0, 8'd255, 8'd0};
  localparam blueRGB = {8'd0, 8'd0, 8'd255};
  localparam yellowRGB = {8'd255, 8'd255, 8'd0};
  localparam purpleRGB = {8'd255, 8'd0, 8'd255};
  localparam whiteRGB = {8'd255, 8'd255, 8'd255};
  localparam eraseRGB = {8'd0, 8'd0, 8'd0};
  localparam brushRGB = {8'd255, 8'd165, 8'd0};

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
