`include "vgaParameters.sv"
`include "colors.sv"

module pixelStore (input  logic clk, reset,
                   input  logic brush,
                   input  logic [2:0] newColor,
                   input  logic [7:0] wx, wy,
                   input  logic [9:0] rx, ry,
                   output logic [2:0] colorCode);

  logic [9:0] rxRam, ryRam;
  logic [2:0] colorCodeRam, testColor;


  // always_comb begin
  //   // subtraction and divison on the inside is the shift amount to center our region
  //   // division by 2 on outside groups pixels into pairs, doubles size
  //   rxRam = (rx * - (HMAX - MAX_COORDINATE)/4)/2;
  //   ryRam = (ry * - (VMAX - MAX_COORDINATE)/4)/2;;

  //   if (rx < ((HACTIVE - MAX_COORDINATE)/4) | ry < ((VACTIVE - MAX_COORDINATE)/4))
  //     colorCode = outside;
  //   else
  //       if (rx > ((HACTIVE - MAX_COORDINATE)*3/4) | ry > ((VACTIVE - MAX_COORDINATE)*3/4))
  //   // if (ry > 128 | rx > 128)
  //     colorCode = outside;
  //   else
  //     colorCode = colorCodeRam;
  // end

  always_comb begin
    // if (rx % 32 == 0 | ry % 32 == 0) colorCode = blue;
    if ($unsigned(rx) > 128 | $unsigned(ry) > 128) colorCode = outside;
    else colorCode = colorCodeRam;
  end

  // assign rxRam = rx;
  // assign ryRam = ry;


// SPRAM
  logic [13:0] resetCount;
  typedef enum logic [1:0] { RAM_SETUP, RAM_READ, RAM_WRITE } RAM_STATE;
  RAM_STATE ramState, ramNextState;

  always_ff @( posedge clk ) begin
    if (reset) begin
      ramState <= RAM_SETUP;
      resetCount <= '0;
    end else begin
      ramState <= ramNextState;
      resetCount <= resetCount + 1'b1;
    end
  end

  always_comb begin
    if (reset) begin
      ramNextState = RAM_SETUP;
    end else begin
      case(ramState)
        RAM_SETUP: begin
                    if ($unsigned(resetCount) == 14'd16383) ramNextState = RAM_READ;
                    else ramNextState = RAM_SETUP;
                  end
        RAM_READ: ramNextState = RAM_WRITE;
        RAM_WRITE: ramNextState = RAM_READ;
        default: ramNextState = RAM_SETUP;
      endcase
    end
  end

  logic [13:0] ramAdr;
  logic ramWE;
  logic [15:0] ramWriteData, ramData;

  always_comb begin
    case(ramState)
      RAM_SETUP: begin
                   ramAdr = resetCount;
                   ramWE = 1'b1;
                   ramWriteData = 16'b000;
                 end
      RAM_READ: begin
                  ramAdr = {ryRam[6:0], rxRam[6:0]};
                  ramWE = 0;
                  ramWriteData = 0;
                end
      RAM_WRITE: begin
                  ramAdr ={wy[6:0], wx[6:0]};
                  ramWE = brush;
                  ramWriteData = {13'b0,newColor};
                end
      default: begin
                 ramAdr = '0;
                 ramWE = '0;
                 ramWriteData = '0;
               end
    endcase
  end


  SP256K spramPixelArray(
  .DI(ramWriteData),
  .AD(ramAdr),
  .MASKWE(4'b1111),
  .WE(ramWE),
  .CS(1'b1),
  .CK(clk),
  .STDBY(1'b0),
  .SLEEP(1'b0),
  .PWROFF_N(1'b1),
  .DO(ramData));

  logic [15:0] ramDataFlopped;

  always_ff @(posedge clk)
    if (reset) ramDataFlopped <= '0;
    else ramDataFlopped <= ramData;

  assign colorCodeRam = ramDataFlopped[2:0];


endmodule
