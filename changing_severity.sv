`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_driver;
  `uvm_component_utils(driver)
  
  function new(string path, uvm_component parent);
    super.new(path,parent);
  endfunction
  
  task run();
    `uvm_info("DRV","info message 1",UVM_NONE);
    `uvm_warning("DRV","potential error");
    `uvm_error("DRV","Error 1");
    #10;
    `uvm_fatal("DRV","terminate simulation DRV");
    #10;
    `uvm_fatal("DRV1","terminate simulation DRV1");
    $diplay("niggers");
  endtask
endclass

module tb;
  driver d;
  initial begin
    d = new("DRV",null);
     // d.set_report_severity_override(UVM_FATAL, UVM_ERROR);
    d.set_report_severity_id_override(UVM_FATAL, "DRV", UVM_ERROR);
    d.run();
  end
endmodule
