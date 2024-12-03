module synchronizer #(parameter WIDTH=1) (
  input  logic             clk, reset,
  input  logic [WIDTH-1:0] async_signal,
  output logic [WIDTH-1:0] sync_signal
);

  logic [WIDTH-1:0] sync_middle;

  always_ff @(posedge clk) begin
    if (reset) begin
      sync_middle <= '0;
      sync_signal <= '0;
    end else begin
      sync_middle <= async_signal;
      sync_signal <= sync_middle;
    end
  end
endmodule
