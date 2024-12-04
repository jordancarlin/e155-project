-L work
-reflib pmi_work
-reflib ovi_ice40up


"C:/Users/jcarlin/Documents/GitHub/e155-project/fpga/src/pixelStore.sv" 
"C:/Users/jcarlin/Documents/GitHub/e155-project/fpga/src/colors.svh" 
"C:/Users/jcarlin/Documents/GitHub/e155-project/fpga/src/vgaParameters.svh" 
"C:/Users/jcarlin/Documents/GitHub/e155-project/fpga/testbench/pixelStore_tb.sv" 
-sv
-optionset VOPTDEBUG
+noacc+pmi_work.*
+noacc+ovi_ice40up.*

-vopt.options
  -suppress vopt-7033
-end

-gui
-top pixelStore_tb
-vsim.options
  -suppress vsim-7033,vsim-8630,3009,3389
-end

-do "view wave"
-do "add wave /*"
