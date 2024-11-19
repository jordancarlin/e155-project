module spiDecode(input  logic       clk,
           input  logic [7:0] spiPacket,
           output logic       brush,
           output logic [7:0] x, y,
           output logic [2:0] newColor);

  typedef enum logic [1:0] { CONF, XPOS, YPOS } SPI_TYPE;
  SPI_TYPE spiType;

  // Determine packet type
  always_ff @(posedge clk)
    if (&spiPacket[7:5]) spiType <= CONF;
    else if (spiType == XPOS) spiType <= YPOS;
    else spiType <= XPOS;

  // flops for data from SPI
  always_ff @(posedge clk )
    case (spiType)
      CONF: begin
              brush    <= spiPacket[4];
              newColor <= spiPacket[2:0];
            end
      XPOS: x <= spiPacket;
      YPOS: y <= spiPacket;
    endcase
endmodule