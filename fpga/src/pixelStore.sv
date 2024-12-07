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
  logic [6:0] testLocMatrix[16383:0] ;
  logic [13:0] testLoc;
  // logic [9:0] counter;
  // logic [21:0] counterBig;

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

  // Create ram
  logic [2:0] colorArray[16384-1:0];
  initial $readmemb("blank.mem", colorArray);
  initial $readmemd("location.mem", testLocMatrix);


  always_comb begin
    // subtraction and divison on the inside is the shift amount to center our region
    // division by 2 on outside groups pixels into pairs, doubles size
    rxRam = rx;// * (MAX_COORDINATE/HMAX); //- (HMAX - MAX_COORDINATE)/4)/2;
    ryRam = ry;// * (MAX_COORDINATE/VMAX); //- (VMAX - MAX_COORDINATE)/4)/2;;

    testLoc = testLocMatrix[{wx[6:0]}];

    // if (rx < ((HACTIVE - MAX_COORDINATE)/4) | ry < ((VACTIVE - MAX_COORDINATE)/4))
    //   colorCode = purple;
    // else
        // if (rx > ((HACTIVE - MAX_COORDINATE)*3/4) | ry > ((VACTIVE - MAX_COORDINATE)*3/4))
    if (ry > 128 | rx > 128)
      colorCode = outside;
    else
      colorCode = colorCodeRam;
    // else if (rx %32==0 | ry %32==0) begin
    //   if (rx == 32 | ry == 32)
    //     colorCode = colorCodeRam;
    //   else if (rx == 64 | ry == 64)
    //     colorCode = green;
    //   else
    //     colorCode = purple;
    // end
    //else
  end



    // if ($unsigned(rx) >= MAX_COORDINATE || $unsigned(ry) >= MAX_COORDINATE) begin
    //   colorCode = 3'b101;
    // end else begin
    //   colorCode = colorCodeRam;
    // end //

  //logic [6:0] temp1, temp2;
  //assign temp1 = 7'd64;
  //assign temp2 = 7'd33;

  // initial begin
  //    $readmemb("testcolor.mem", colorArray);
  //  end

  // initial $readmemb("green.mem", colorArray[{7'd55,7'd55}]);

  // logic re, we;

  // always_ff @(posedge clk) begin
  //   if (reset) begin
  //     re <= 0;
	// // counterBig <= 0;
	// // counter <= 256;
  //   end else begin
  //     if(re) re <=0;
  //     else   re <=1;
	// // counterBig <= counterBig + 1;
	// // if (counterBig[20])
	// // 	if (counter == 383)
	// // 		counter <= 256;
	// // 	else
	// // 		counter <= counter +1;
	// // else
	// // 	counter <= counter + 0;
	// // 	  end
  //   end
  // end

  // assign we = ~re;
  // logic [13:0] adr;
  // assign adr = (wy[6:0] << 7) + {7'b0, wx[6:0]};

  always_ff @(posedge clk)
    // if (re)
		colorCodeRam <= colorArray[{ryRam[6:0],rxRam[6:0]}];
	//end;



  always_ff @(posedge clk) begin
    //colorArray[{wy[6:0],wx[6:0]}] <= newColor;
    colorArray[{129}] <= newColor;

  //colorArray[{50,50}] <= green;
  //colorArray[{49,50}] <= green;
	//colorArray[928] <= blue;
	//colorArray[1000] <= red;
	//colorArray[1010] <= white;
	//colorArray[1020] <= red;
	//colorArray[1024] <= white;
	//colorArray[1065] <= red;
	//colorArray[128] <= white;
	//colorArray[257] <= purple;
	//colorArray[384] <= green;
	// colorArray[counter] <= green;

	//colorArray[628] <= white;
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
