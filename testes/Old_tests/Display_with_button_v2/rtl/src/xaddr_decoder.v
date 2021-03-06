`include "xdefs.vh"
`timescale 1ns / 1ps

module xaddr_decoder (
	             // address and global select signal
	              input [`ADDR_W-1:0] addr,
                      input 		  sel,
		      input        Btn3,
                      input             [7:0]  Sw,
                      // ports
                      output reg 	  led0_sel,
		      output reg 	  btn3_sel,
		      output reg 	  sw_sel,
                      

                      //memory
	              output reg 	  mem_sel,
                      input [31:0] 	  mem_data_to_rd,

	              output reg 	  regf_sel,
                      input [31:0] 	  regf_data_to_rd,

`ifdef DEBUG	
	              output reg 	  cprt_sel,
`endif

`ifdef EXT_BASE
                      output reg 	  ext_sel,
                      input [31:0] 	  ext_data_to_rd,
`endif
                      
                      output reg 	  trap_sel,

                      //read port
                      output reg [31:0]   data_to_rd
                     );

   
   //select module
   always @* begin
      btn3_sel = 1'b0;
      sw_sel = 1'b0;
      led0_sel = 1'b0;
      mem_sel = 1'b0;
      regf_sel = 1'b0;
`ifdef DEBUG
      cprt_sel = 1'b0;
`endif
`ifdef EXT_BASE
      ext_sel = 1'b0;
`endif
      trap_sel = 1'b0;

      //mask offset and compare with base
      if ( (addr & {  {`ADDR_W-`MEM_ADDR_W{1'b1}}, {`MEM_ADDR_W{1'b0}}  }) == `MEM_BASE)
        mem_sel = sel;
      else if ( (addr & {  {`ADDR_W-`REGF_ADDR_W{1'b1}}, {`REGF_ADDR_W{1'b0}}  }) == `REGF_BASE)
        regf_sel = sel;
`ifdef DEBUG
      else if ( (addr &  {  {`ADDR_W-`CPRT_ADDR_W{1'b1}}, {`CPRT_ADDR_W{1'b0}}  }) == `CPRT_BASE)
        cprt_sel = sel;
`endif
`ifdef EXT_BASE
      else if ( (addr &  {  {`ADDR_W-`EXT_ADDR_W{1'b1}}, {`EXT_ADDR_W{1'b0}}  }) == `EXT_BASE)
        ext_sel = sel;
`endif
      else if ( (addr &  {  {`ADDR_W-`LED0_ADDR_W{1'b1}}, {`LED0_ADDR_W{1'b0}}  }) == `LED0_BASE)
        led0_sel = sel;
      else if ( (addr &  {  {`ADDR_W-`SW_ADDR_W{1'b1}}, {`SW_ADDR_W{1'b0}}  }) == `SW_BASE)
        sw_sel = sel;
      else if ( (addr &  {  {`ADDR_W-`BTN3_ADDR_W{1'b1}}, {`BTN3_ADDR_W{1'b0}}  }) == `BTN3_BASE)
        btn3_sel = sel;
      else
          trap_sel = sel;
   end

   //select data to read
   always @(*) begin
      data_to_rd = `DATA_W'd0;

      if(mem_sel)
        data_to_rd = mem_data_to_rd;
      else if(regf_sel)
        data_to_rd = regf_data_to_rd;
       else if(sw_sel)
        data_to_rd = Sw;
      else if(btn3_sel)
        data_to_rd = Btn3; 
   
`ifdef EXT_BASE
      else if(ext_sel)
        data_to_rd = ext_data_to_rd;
`endif
   end

endmodule
