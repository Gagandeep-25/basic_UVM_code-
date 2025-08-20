`include "uvm_macros.svh"
import uvm_pkg::*;
 
class obj extends uvm_object;
//  `uvm_object_utils(obj)
 
  function new(string path = "obj");
    super.new(path);
  endfunction
  
  rand bit [3:0] a;
  rand bit [7:0] b;
  
 
  `uvm_object_utils_begin(obj)
  `uvm_field_int(a, UVM_NOPRINT | UVM_BIN);
  `uvm_field_int(b, UVM_DEFAULT | UVM_DEC);
  `uvm_object_utils_end
 
  
endclass
 
module tb;
  obj o;
  
  initial begin
    o = new("obj");
    o.randomize();
    o.print(uvm_default_table_printer);
  end
  
endmodule

/*

in the above code , 
a:
  UVM_NOPRINT → don’t print this field when calling .print().
  UVM_BIN → if it was printed, it would be shown in binary.
b:
  UVM_DEFAULT → normal behavior.
  UVM_DEC → print in decimal format.

o.print(uvm_default_table_printer) → prints the object in a nice UVM table format.

in the expected output , Field a is missing (because of UVM_NOPRINT).
Field b is printed (as an 8-bit random decimal number). 
*/
