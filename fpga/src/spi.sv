// Jordan Carlin (jcarlin@hmc.edu) and Zoe Worrall (zworrall@g.hmc.edu)
// December 2024
// SPI FIFO module

module spi (input  logic       sck, sdi, cs,
            output logic [7:0] spiPacket1, spiPacket2);

  // Shift in data on rising edge of sck when cs is high
  always_ff @(posedge sck)
    if (cs) {spiPacket1, spiPacket2} = {spiPacket1[6:0], spiPacket2, sdi};

endmodule
