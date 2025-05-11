class ahb5_environment;
  int addr_width, data_width;
  //ahb5_configure cfg;
  ahb5_generator gen;
  ahb5_driver drv;
  ahb5_transaction trans;
  ahb5_monitor mon;
  ahb5_scoreboard scb;
  mailbox gen2drv;
  mailbox mon2scb;
  testcase_t testcase;
  virtual ahb5_interface intf;
  int no_of_wr;
  int no_of_rd;
  event event_a;
  event reset_deasserted;
  int no_of_random;


  function new(virtual ahb5_interface intf, int no_of_wr, int no_of_rd, int no_of_random, testcase_t testcase);
    this.no_of_wr = no_of_wr;
    this.no_of_rd = no_of_rd;
    this.testcase = testcase;
    this.no_of_random = no_of_random;
    this.intf = intf;
    gen2drv = new(1);
    mon2scb = new(1);
    //cfg = new();
    gen = new(gen2drv, no_of_wr, no_of_rd, no_of_random, testcase, reset_deasserted);
    drv = new(gen2drv, intf.ahb5_driver, reset_deasserted);
    mon = new(mon2scb, intf, event_a);
    scb = new(mon2scb, testcase);
  endfunction

  task test_run();
    fork
      gen.main();
      drv.main();
      mon.main();
      scb.main();
    join_any
    $display("[%0t] VANDAN Generator is ended",$time);
    repeat(2) begin
      @(negedge intf.Hclk);
    end
    $finish;
  endtask

endclass
