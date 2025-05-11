import AT_ahb5_pkg_p::*;
//Test contain non reusable component and environment and test take data and interface from tb_top module and pass to environment and non reusable component
program AT_ahb5_test_p(AT_ahb5_interface_i intf);
  //Declaration of environment instance and non reusable component instance and signals
  testcase_t AT_testcase_te; //Testcase
  int AT_no_of_wr_i=5; //No of write transactions
  int AT_no_of_rd_i=5; //No of read transactions
  int AT_no_of_random_i=6; //No of random transactions
  AT_ahb5_environment_c env; //Environment Instance
  AT_ahb5_slave_dummy_driver_c dum_drv; //slave_dummy_driver instance

  //Take testcase value from makefile and if it not given from testcase then it automatically select SANITY Testcase
  initial begin
          if(!$value$plusargs ("STRING=%s", AT_testcase_te)) begin 
            AT_testcase_te = SANITY_TESTCASE;
            $display("Default Testcase is SANITY_TESTCASE");
          end
  end

  //Pass interface and signals to environment and slave_dummy_driver and call their main task
  initial begin
    env = new(intf, AT_no_of_wr_i, AT_no_of_rd_i, AT_no_of_random_i, AT_testcase_te);    
    dum_drv = new(intf);
    fork
      env.AT_main_t(); //Environment Main task
      dum_drv.AT_main_t(); //Dummy driver Main task
    join
  end
endprogram
