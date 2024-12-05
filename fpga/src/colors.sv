`ifndef COLORS
`define COLORS

parameter erase = 3'b000;
parameter red = 3'b001;
parameter blue = 3'b010;
parameter green = 3'b011;
parameter yellow = 3'b100;
parameter purple = 3'b101;
parameter white = 3'b111;
parameter outside = 3'b110;

parameter redRGB = {4'hF, 4'h0, 4'h0};
parameter greenRGB = {4'h0, 4'hF, 4'h0};
parameter blueRGB = {4'h0, 4'h0, 4'hF};
parameter yellowRGB = {4'hF, 4'hF, 4'h0};
parameter purpleRGB = {4'hF, 4'h0, 4'hF};
parameter whiteRGB = {4'hF, 4'hF, 4'hF};
parameter eraseRGB = {4'h0, 4'h0, 4'h0};
parameter brushRGB = {4'hC, 4'h6, 4'h0};
parameter outsideRGB = {4'h5, 4'h6, 4'h7};

`endif // COLORS
