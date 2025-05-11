//Environment contain all the reusable components and give connection to all reusable components
class AT_ahb5_environment_c;
  //Declaration of instance of reusable components and signals
  AT_ahb5_generator_c gen; //Generator Instance
  AT_ahb5_driver_c drv; //Driver Instance
  AT_ahb5_monitor_c mon; //Monitor Instance
  AT_ahb5_scoreboard_c scb; //Scoreboard Instance
  mailbox AT_gen2drv_m; //Mailbox for Generator and driver
  mailbox AT_mon2scb_m; //Mailbox for Monitor and Scoreboard
  testcase_t AT_testcase_te; //Testcase
  virtual AT_ahb5_interface_i intf; //Interface
  int AT_no_of_wr_i; //Number of Write transactions
  int AT_no_of_rd_i; //Number of Read transactions
  event AT_reset_deasserted_e; //Reset event for generator and driver
  int AT_no_of_random_i; //Number of Random transactions

  //Constructor of Environment
  function new(virtual AT_ahb5_interface_i intf, int AT_no_of_wr_i, int AT_no_of_rd_i, int AT_no_of_random_i, testcase_t AT_testcase_te);
    this.AT_no_of_wr_i = AT_no_of_wr_i;
    this.AT_no_of_rd_i = AT_no_of_rd_i;
    this.AT_testcase_te = AT_testcase_te;
    this.AT_no_of_random_i = AT_no_of_random_i;
    this.intf = intf;
    AT_gen2drv_m = new(1);
    AT_mon2scb_m = new(1);
    gen = new(AT_gen2drv_m, AT_no_of_wr_i, AT_no_of_rd_i, AT_no_of_random_i, AT_testcase_te, AT_reset_deasserted_e);
    drv = new(AT_gen2drv_m, intf.ahb5_driver, AT_reset_deasserted_e);
    mon = new(AT_mon2scb_m, intf);
    scb = new(AT_mon2scb_m, AT_testcase_te);
  endfunction

  //Main task of Environment
  //all reusable componets main task called inside fork join for parallel process   
  task AT_main_t();
    fork
      gen.AT_main_t(); //generator main task
      drv.AT_main_t(); //driver main task
      mon.AT_main_t(); //monitor main task
      scb.AT_main_t(); //scoreboard main task
    join_any
    $display("[%0t] Generator is ended",$time);
    repeat(2) begin
      @(negedge intf.AT_Hclk_l);
    end
    $finish;
  endtask

endclass
