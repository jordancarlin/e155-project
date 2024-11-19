module imageLookup(input logic pen,
                   input logic [9:0] x, y,
                   output logic [7:0] r, g, b);

  localparam red = 3'd1;
  localparam green = 3'd2;
  localparam blue = 3'd3;
  localparam yellow = 3'd4;
  localparam purple = 3'd5;
  localparam white = 3'd6;
  localparam erase = 3'd7;
  
  localparam redRGB = {8'255, 8'd0, 8'd0};
  localparam greenRGB = {8'0, 8'd255, 8'd0};
  localparam blueRGB = {8'0, 8'd0, 8'd255};
  localparam yellowRGB = {8'255, 8'd255, 8'd0};
  localparam purpleRGB = {8'255, 8'd0, 8'd255};
  localparam whiteRGB = {8'255, 8'd255, 8'd255};
  localparam eraseRGB = {8'0, 8'd0, 8'd0};
  localparam penRGB = {8'255, 8'd165, 8'd0};

  // given x and y position, return the color
  pixelStore pixelStore(.x, .y, .color);

  // convert color to rgb values
  always_comb begin
    if(pen) begin
      {r, g, b} = penRGB;
    end else
    case(color)
      red: {r, g, b} = redRGB;
      green: {r, g, b} = greenRGB;
      blue: {r, g, b} = blueRGB;
      yellow: {r, g, b} = yellowRGB;
      purple: {r, g, b} = purpleRGB;
      white: {r, g, b} = whiteRGB;
      erase: {r, g, b} = eraseRGB;
    endcase
  end
endmodule