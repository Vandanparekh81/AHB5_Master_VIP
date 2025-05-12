import AT_ahb5_pkg_p::*;
//Test contain non reusable component and environment and test take data and interface from tb_top module and pass to environment and non reusable component
program AT_ahb5_test_p(AT_ahb5_interface_i intf);
  //Declaration of environment instance and non reusable component instance and signals
  testcase_t AT_testcase_te; //Testcase
  real AT_clk_period_r;
  real AT_freq_r;
  int AT_no_of_wr_i; //No of write transactions
  int AT_no_of_rd_i; //No of read transactions
  int AT_no_of_random_i; //No of random transactions
  AT_ahb5_environment_c env; //Environment Instance
  AT_ahb5_slave_dummy_driver_c dum_drv; //slave_dummy_driver instance

  initial begin

          //Take testcase value from makefile and if the value of testcase not given from makefile then it automatically select SANITY Testcase
          if(!$value$plusargs ("STRING=%s", AT_testcase_te)) begin 
            AT_testcase_te = SANITY_TESTCASE;
            $display("Default Testcase is SANITY_TESTCASE");
          end

          //Take number of write value from makefile and if the value of number of write not given from makefile then it automatically select 1
          if(!$value$plusargs ("NO_OF_WRITE=%0d", AT_no_of_wr_i)) begin 
            AT_no_of_wr_i = 1;
            $display("Default Value of number of write is 1");
          end

          //Take number of read value from makefile and if the value of number of read not given from makefile then it automatically select 1
          if(!$value$plusargs ("NO_OF_READ=%0d", AT_no_of_rd_i)) begin 
            AT_no_of_rd_i = 1;
            $display("Default value of number of read is 1");
          end

          //Take number of random value from makefile and if the value of number of random not given from makefile then it automatically select 5
          if(!$value$plusargs ("NO_OF_RANDOM=%0d", AT_no_of_random_i)) begin 
            AT_no_of_random_i = 5;
            $display("Default value of number of random read and write is 1");
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
