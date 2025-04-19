`include "../sv/ahb5_environment.sv"
program ahb5_test(ahb5_interface intf);
  ahb5_environment env;



  initial begin
    env = new(intf);
    env.test_run();
  end
endprogram
