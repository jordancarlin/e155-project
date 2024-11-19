module spi (input  logic       sck, sdi,
            output logic       sdo,
            output logic [7:0] spiPacket);

  logic [7:0] spiPacketCaptured;

  always_ff @(posedge sck)
    {spiPacketCaptured, spiPacket} = {spiPacket[6:0], sdi}; // this logic doesn't seem quite right yet

  assign sdo = 0;
endmodule
