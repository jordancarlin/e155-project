module spi (input  logic       sck, sdi, cs,
            output logic [7:0] spiPacket1, spiPacket2);

  always_ff @(posedge sck)
    if (cs) {spiPacket1, spiPacket2} = {spiPacket1[6:0], spiPacket2, sdi};

endmodule
