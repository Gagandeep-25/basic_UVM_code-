`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_driver;
  `uvm_component_utils(driver)
  
  function new(string path, uvm_component parent);
    super.new(path,parent);
  endfunction
  
  task run();
    `uvm_info("DRV","message 1",UVM_NONE);
    `uvm_warning("DRV","warining 1");
    `uvm_error("DRV","error 1");
    #10;
    `uvm_fatal("DRV","terminate simulation");
  endtask
endclass

module tb;
  driver d;
  
  initial begin
    d= new("DRV",null);
    d.run();
  end
endmodule 
