module spi(input logic
);

  // flops for data from SPI
  always_ff @( clock ) begin
    if (position) begin
      x <= spiX;
      y <= spiY;
    end else if (conf) begin
      brush <= spiBrush;
      newColor <= spiColor;
    end
  end

endmodule