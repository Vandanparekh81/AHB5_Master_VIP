`include "ahb5_transaction.sv"
`include "ahb5_generator.sv"
`include "ahb5_driver.sv"
`include "ahb5_monitor.sv"
`include "ahb5_scoreboard.sv"
class ahb5_environment;
  ahb5_generator gen;
  ahb5_driver drv;
  ahb5_transaction trans;
  ahb5_monitor mon;
  ahb5_scoreboard scb;
  mailbox gen2drv;
  mailbox mon2scb;
  virtual ahb5_interface intf;
  event event_a;


  function new(virtual ahb5_interface intf);  
    this.intf = intf;
    gen2drv = new(1);
    mon2scb = new(1);
    gen = new(gen2drv, 5, event_a);
    drv = new(gen2drv, intf.ahb5_driver);
    mon = new(mon2scb, intf.ahb5_monitor, event_a);
    scb = new(mon2scb);
  endfunction

  task test_run();
    fork
      gen.main();
      drv.main();
      mon.main();
      scb.main();
    join
  endtask

endclass
