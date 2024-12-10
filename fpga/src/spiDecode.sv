// Jordan Carlin (jcarlin@hmc.edu) and Zoe Worrall (zworrall@g.hmc.edu)
// December 2024
// SPI packet decoder module

`include "colors.sv"
module spiDecode(input  logic       ready,
                 input  logic [7:0] spiPacket1, spiPacket2,
                 output logic       updateConfig, updatePosition,
                 output logic       brush,
                 output logic [2:0] newColor,
                 output logic [7:0] x, y);

  typedef enum logic { CONF, POS } SPI_TYPE;
  SPI_TYPE spiType;

  logic [7:0] spiPacket1Ready, spiPacket2Ready;

  assign spiPacket1Ready = ready ? spiPacket1 : '0;
  assign spiPacket2Ready = ready ? spiPacket2 : '0;

  // Determine packet type
  always_comb
    if (&spiPacket1[7:5]) spiType <= CONF;
    else spiType <= POS;

  // Decode packet into brush, color, and position based on type
  always_comb begin
    brush = '0;
    newColor = green;//'0;
    x = '0;
    y = '0;
    updateConfig = '0;
    updatePosition = '0;
    case (spiType)
      CONF: begin
              brush    = spiPacket1Ready[4];
              newColor = spiPacket1Ready[2:0];
              updateConfig = 1 & ready;
            end
      POS: begin
              x = spiPacket1Ready;
              y = spiPacket2Ready;
              updatePosition = 1 & ready;
           end
    endcase
  end
endmodule
