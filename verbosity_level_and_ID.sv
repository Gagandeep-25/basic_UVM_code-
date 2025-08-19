`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_driver;
  `uvm_component_utils(driver)
  
  function new(string path,uvm_component parent);
    super.new(path,parent);
  endfunction
  
  task run();
    `uvm_info("DRV1","Executed DRV1 code",UVM_HIGH);
    `uvm_info("DRV2","Executed DRV2 code",UVM_HIGH);
  endtask
endclass

module tb;
  driver drv;
  initial begin
    drv = new("DRV",null);
    drv.set_report_id_verbosity("DRV1",UVM_HIGH);
    drv.run();
  end
endmodule

/*

in the above code , since we change the verbosity of DRV1, only they is visible 
when we call the run task 

*/
