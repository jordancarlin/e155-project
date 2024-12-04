
`ifndef VGA_PARAMETERS
`define VGA_PARAMETERS

parameter HBP = 10'd48; // horizontal back porch
parameter HACTIVE = 10'd640; // number of pixels per line
parameter HFP = 10'd16; // horizontal front porch
parameter HSYN = 10'd96; // horizontal sync pulse = 60 to move electron gun back to left
parameter HMAX = HBP + HACTIVE + HFP + HSYN; //48+640+16+96=800: number of horizontal pixels
parameter VBP = 10'd32; // vertical back porch
parameter VACTIVE = 10'd480; // number of lines
parameter VFP = 10'd11; // vertical front porch
parameter VSYN = 10'd2; // vertical sync pulse = 2 to move electron gun back to top
parameter VMAX = VBP + VACTIVE + VFP + VSYN; //32+480+11+2=525: number of vertical pixels

parameter MAX_COORDINATE = 180; // max coordinate for drawing

`endif // VGA_PARAMETERS
