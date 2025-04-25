//`include "../sv/ahb5_environment.sv"
import ahb5_pkg::*;
program ahb5_test(ahb5_interface intf);
  testcase_t testcase;
  
  ahb5_environment env;
  initial begin
    env = new(intf, 5, 5, WRITE_TEST);    
    env.test_run();
  end
endprogram
