//`include "../sv/ahb5_environment.sv"
import ahb5_pkg::*;
program ahb5_test(ahb5_interface intf);
  testcase_t testcase;
  int no_of_wr=5;
  int no_of_rd=5;
  int no_of_random=6;
  ahb5_environment env;
  ahb5_slave_dummy_driver dum_drv;

  initial begin
    forever @(negedge intf.HResetn) begin
      env.drv.reset();
    end
  end
  initial begin
    env = new(intf, no_of_wr, no_of_rd, no_of_random, DIRECTED_TESTCASE);
    dum_drv = new(intf);
    fork
      env.test_run();
      dum_drv.main();
    join
  end
endprogram
