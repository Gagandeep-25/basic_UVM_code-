# Basic UVM Code Repository

This repository contains small, focused SystemVerilog/UVM examples demonstrating common **UVM** methods, macros, and reporting features across multiple files.

***

## Overview

This repo is a collection of basic UVM code snippets that illustrate how to:

- Use UVM reporting macros for printing and verbosity control.
- Register objects and fields with the factory and automation macros.
- Work with arrays, queues, and associative arrays using UVM field macros.
- Use core uvm_object methods like `print`, `copy`, `compare`, and `convert2string`.
- Manipulate report verbosity and severity at runtime.

Each `.sv` file is self‑contained and can be compiled independently to see a specific concept in action.

***

## Global Includes and Imports

Across the examples, the following are common:

- `` `include "uvm_macros.svh"``
  - Brings in all standard UVM macros such as reporting macros, factory/field registration macros, and utilities.

- `import uvm_pkg::*;`
  - Imports the UVM package so classes like `uvm_object`, `uvm_driver`, `uvm_top`, and enums like `UVM_HIGH`, `UVM_NONE` are visible.

- Class extension from `uvm_object` / `uvm_component`
  - Enables use of UVM base class features like factory creation, `print`, `copy`, `compare`, and reporting configuration.

***

## File: `UVM_printing_data.sv`

### Methods and Macros

- `` `uvm_info(ID, MSG, VERBOSITY)``
  - Prints an informational UVM report with the given ID and verbosity.
  - Here: prints `"Value of data : %d"` with `UVM_NONE` verbosity from module `tb`.

- `$sformatf()`
  - SystemVerilog function that creates a formatted string, used to embed `data` into the message.

***

## File: `array_macros_field.sv`

### Class: `array extends uvm_object`

- `function new(string path = "array"); super.new(path); endfunction`
  - Constructor that passes a name to the base `uvm_object`.

- `` `uvm_object_utils_begin(array)` / `` `uvm_object_utils_end`
  - Registers the class with the UVM factory and enables automation for field operations (print/copy/compare/pack/unpack) for registered fields.

- `` `uvm_field_sarray_int(arr1, UVM_DEFAULT)``
  - Declares `arr1` (static array of int) as an integral field to be included in automation (print, copy, compare etc.).

- `` `uvm_field_array_int(arr2, UVM_DEFAULT)``
  - Registers a dynamic array of int (`arr2`) for automation.

- `` `uvm_field_queue_int(arr3, UVM_DEFAULT)``
  - Registers a queue of int (`arr3`) for automation.

- `` `uvm_field_aa_int_int(arr4, UVM_DEFAULT)``
  - Registers an associative array of int indexed by int (`arr4`) for automation.

- `task run(); ... endtask`
  - Fills `arr2`, `arr3`, and `arr4` with sample values to demonstrate how they are printed.
  - `arr3.push_front()` and indexed assignments show usage of queues and associative arrays.

- `a.print();`
  - Calls `uvm_object::print()` to display all registered fields using the UVM printer.

***

## File: `change_display_verbosity.sv`

### Verbosity Control

- `uvm_top.get_report_verbosity_level`
  - Returns the current global verbosity level used by the UVM report server.

- `$display("default : %0d", uvm_top.get_report_verbosity_level);`
  - Shows the default verbosity value (e.g., corresponding to `UVM_MEDIUM`).

- `uvm_top.set_report_verbosity_level(UVM_HIGH);`
  - Changes the verbosity for the entire testbench hierarchy to `UVM_HIGH` at runtime.

- `` `uvm_info("TB_TOP", "string xyz", UVM_HIGH)``
  - Issues an info message at `UVM_HIGH` verbosity; visible only if the verbosity level is at least `UVM_HIGH`.

***

## File: `changing_severity.sv`

### Class: `driver extends uvm_driver`

- `` `uvm_component_utils(driver)``
  - Registers the component with the UVM factory and enables configuration/printing utilities.

- `function new(string path, uvm_component parent); super.new(path,parent); endfunction`
  - Standard component constructor passing name and parent to the base class.

### Reporting in `task run()`

- `` `uvm_info("DRV", "info message 1", UVM_NONE)``
  - Prints a non‑verbose info message from component `DRV`.

- `` `uvm_warning("DRV", "potential error")``
  - Issues a warning message with ID `"DRV"`.

- `` `uvm_error("DRV", "Error 1")``
  - Issues an error message with ID `"DRV"`.

- `` `uvm_fatal("DRV", "terminate simulation DRV")`` / second `uvm_fatal`
  - Issues a fatal error which normally terminates simulation.

### Severity Overrides

- `d.set_report_severity_id_override(UVM_FATAL, "DRV", UVM_ERROR);`
  - Changes all `UVM_FATAL` reports with ID `"DRV"` to `UVM_ERROR`, allowing simulation to continue where it would normally stop.

***

## File: `compare_method.sv`

### Class: `first extends uvm_object`

- `rand bit [3:0] data;`
  - Randomizable 4‑bit data field.

- `` `uvm_object_utils_begin(first)` / `` `uvm_field_int(data, UVM_DEFAULT)` / `` `uvm_object_utils_end`
  - Registers the class and its `data` field for factory and automation, so `print`, `copy`, and `compare` work on `data`.

### Usage in `tb`

- `f1.randomize();`
  - Randomizes `data` of `f1` using standard UVM/SV randomization.

- `f2.copy(f1);`
  - Copies all registered fields from `f1` into `f2` (here, just `data`).

- `f1.print(); f2.print();`
  - Prints internal state of each object, including `data`.

- `status = f1.compare(f2);`
  - Compares all registered fields and returns 1 if equal, 0 otherwise; here expected to be 1 because of the copy.

***

## File: `convert2string_method.sv`

### Class: `obj extends uvm_object`

- `` `uvm_object_utils(obj)``
  - Registers the object with the UVM factory and enables automation.

- Local fields: `bit [3:0] a`, `string b`, `real c`
  - Simple data members to be formatted into a string.

### Overridden Method

- `virtual function string convert2string();`
  - Extends the base `uvm_object::convert2string()` behaviour to create a detailed string representation of `obj`.
  - Uses `$sformatf()` to append `"a : %0d"`, `"b : %0s"`, `"c : %0f"` to the base string.

### Usage in `tb`

- `o = obj::type_id::create("o");`
  - Creates `obj` via the UVM factory using the registered `type_id`.

- `` `uvm_info("TB_TOP", $sformatf("%0s", o.convert2string()), UVM_NONE)``
  - Prints the string returned by `convert2string()` using a UVM info message.

***

## Other Files

From the file list, similar patterns apply:

- `copy_and_clone_method.sv` / `copy_clone_2.sv`
  - Demonstrate `copy()` vs `clone()` to duplicate uvm_object instances and their fields.

- `create_method.sv`
  - Demonstrates factory creation (`::type_id::create`) for components/objects.

- `do_copy_method.sv`, `do_print_method.sv`
  - Override `do_copy` / `do_print` to customize copy/print behaviour while still using automation.

- `field_macros_1.sv`, `field_macros_2.sv`, `field_macros_3.sv`
  - Show different `uvm_field_*` macros for scalar, array, and object fields.

- `max_quit_count.sv`
  - Configures maximum number of errors before simulation quits using UVM report server knobs.

- `other_macros.sv`
  - Shows additional utility macros from `uvm_macros.svh`.

- `override_type.sv`
  - Demonstrates UVM type overrides (factory overrides) for replacing one type with another at runtime.

- `shallow_copy.sv`
  - Shows the difference between shallow copy (default) and deep copy for objects / handles.

- `verbosity_level_and_ID.sv`, `verbosity_level_of_entire_hierarchy.sv`
  - Expand on control of verbosity per component, per ID, and across the entire hierarchy.

***

## Key UVM Concepts

### Factory Registration
- `` `uvm_object_utils(classname)`` or `` `uvm_component_utils(classname)``
  - Enables `::type_id::create()` for dynamic object creation.
  - Allows runtime factory overrides for polymorphic behavior.

### Field Automation
- `` `uvm_field_*`` macros register fields for automatic `print()`, `copy()`, `compare()`, `pack()`, and `unpack()` operations.
- Examples: `` `uvm_field_int``, `` `uvm_field_string``, `` `uvm_field_array_int``, `` `uvm_field_aa_int_int``

### Reporting
- `` `uvm_info``, `` `uvm_warning``, `` `uvm_error``, `` `uvm_fatal`` macros generate messages with configurable verbosity and severity.
- Severity and verbosity can be modified at runtime using `set_report_*` methods.

### Core Methods
- `print()` – Displays object state based on registered fields.
- `copy(source)` – Copies all registered fields from source.
- `clone()` – Returns a deep copy of the object.
- `compare(rhs)` – Compares all registered fields, returns 1 if equal.
- `convert2string()` – Returns a string representation (often overridden for custom formatting).

***

## License

This is a basic educational repository for UVM learning and verification concepts.
