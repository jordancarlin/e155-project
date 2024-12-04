`include "vgaParameters.svh"
`include "colors.svh"

module pixelStore (input  logic clk, reset,
                   input  logic brush,
                   input  logic [2:0] newColor,
                   input  logic [7:0] wx, wy,
                   input  logic [9:0] rx, ry,
                   output logic [2:0] colorCode);

  logic [9:0] rxRam, ryRam;
  logic [2:0] colorCodeRam, testColor;
  logic [31:0] counter;

  // always_ff @(posedge clk) begin
  //   if (reset) begin
  //     testColor <= erase;
  //     counter <= '0;
  //   end else if (counter < 16000) begin
  //     testColor <= red;
  //     counter <= counter + 1;
  //   end else if (counter < 32000) begin
  //     testColor <= blue;
  //     counter <= counter + 1;
  //   end else if (counter < 48000) begin
  //     testColor <= green;
  //     counter <= counter + 1;
  //   end else if (counter < 65000) begin
  //     testColor <= red;
  //     counter <= counter + 1;
  //   end else begin
  //     testColor <= yellow;
  //     counter <= '0;
  //   end
  // end


  always_comb begin
    // subtraction and divison on the inside is the shift amount to center our region
    // division by 2 on outside groups pixels into pairs, doubles size
    rxRam = rx;// * (MAX_COORDINATE/HMAX); //- (HMAX - MAX_COORDINATE)/4)/2;
    ryRam = ry;// * (MAX_COORDINATE/VMAX); //- (VMAX - MAX_COORDINATE)/4)/2;

    // if (rx < ((HACTIVE - MAX_COORDINATE)/4) | ry < ((VACTIVE - MAX_COORDINATE)/4))
    //   colorCode = purple;
    // else 
        // if (rx > ((HACTIVE - MAX_COORDINATE)*3/4) | ry > ((VACTIVE - MAX_COORDINATE)*3/4))
    if (rx %50==0 | ry %50==0) begin
      if (rx == 50 | ry == 50)
        colorCode = colorCodeRam;
      else
       colorCode = purple;
    end
    else
      colorCode = colorCodeRam;
  end

    // if ($unsigned(rx) >= MAX_COORDINATE || $unsigned(ry) >= MAX_COORDINATE) begin
    //   colorCode = 3'b101;
    // end else begin
    //   colorCode = colorCodeRam;
    // end //

  logic [6:0] temp1, temp2;
  assign temp1 = 7'd50;
  assign temp2 = 7'd125;

  logic [2:0] colorArray[16384-1:0];

  always_ff @(posedge clk) begin
    colorCodeRam <= colorArray[{ryRam[6:0],rxRam[6:0]}];
    if (reset)
      colorArray[{wy[6:0], wx[6:0]}] <= '0;
    else if (1'b1)
      colorArray[{wy[6:0], wx[6:0]}] <= newColor;
  end


  // pixelRam pixelRam(
  //   .wr_clk_i(clk),
  //   .rd_clk_i(clk),
  //   .rst_i(reset),
  //   .wr_clk_en_i(1'b0),
  //   .rd_en_i(1'b1),
  //   .rd_clk_en_i(1'b0),
  //   .wr_en_i(1'b1),//brush),
  //   .wr_data_i(green),
  //   .wr_addr_i({ryRam[6:0], temp2}),//{wy[6:0],wx}),
  //   .rd_addr_i({ryRam[6:0],rxRam[6:0]}),
  //   .rd_data_o(colorCodeRam));
endmodule
