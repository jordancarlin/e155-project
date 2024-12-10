// Jordan Carlin (jcarlin@hmc.edu) and Zoe Worrall (zworrall@g.hmc.edu)
// December 2024
// SPI FSM controller

module spiFSM(input clk, reset, cs,
              output ready);

  typedef enum logic [1:0] { SPI_IDLE, SPI_HOLD, SPI_DONE } SPI_STATE;
  SPI_STATE spiState, spiNextState;

  always_ff @(posedge clk) begin
    if (reset) begin
      spiState <= SPI_IDLE;
    end else begin
      spiState <= spiNextState;
    end
  end

  // FSM next state logic
  // Wait for cs to go high, then hold until cs goes low, then assert done and return to waiting
  always_comb begin
    case (spiState)
      SPI_IDLE: begin
                  if (cs) spiNextState = SPI_HOLD;
                  else spiNextState = SPI_IDLE;
                end
      SPI_HOLD: begin
                  if (cs) spiNextState = SPI_HOLD;
                  else spiNextState = SPI_DONE;
                end
      SPI_DONE: spiNextState = SPI_IDLE;
      default: spiNextState = SPI_IDLE;
    endcase
  end

  assign ready = spiState == SPI_DONE;

endmodule
