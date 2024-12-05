module spiFSM(input clk, reset, cs,
              output ready, test);

  typedef enum logic [1:0] { SPI_IDLE, SPI_HOLD, SPI_DONE } SPI_STATE;
  SPI_STATE spiState, spiNextState;
  
  //logic testTemp;
  //assign test = testTemp;

  always_ff @(posedge clk) begin
    if (reset) begin
      spiState <= SPI_IDLE;
    end else begin
      spiState <= spiNextState;
    end
  end

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
      SPI_DONE: spiNextState = SPI_DONE;
      default: spiNextState = SPI_IDLE;
    endcase
  end

  // assign test = spiState == SPI_DONE;
  assign ready = spiState == SPI_DONE;

endmodule
