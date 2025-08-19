// VERBOSITY MANUPLATION 

`include "uvm_macros.svh"
import uvm_pkg::*;

/*

code for displaying default verbosity

module tb;
  initial begin
    $display("default : %0d",uvm_top.get_report_verbosity_level);   //UVM_MEDIUM   200
  end
endmodule


*/

module tb;
  initial begin
    $display("default : %0d",uvm_top.get_report_verbosity_level);
    #10;
    uvm_top.set_report_verbosity_level(UVM_HIGH);
    `uvm_info("TB_TOP","string xyz",UVM_HIGH);
  end
endmodule 
