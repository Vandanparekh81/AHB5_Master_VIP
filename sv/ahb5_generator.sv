import ahb5_pkg::*;
class ahb5_generator;
  mailbox gen2drv;
  int no_of_wr;
  int no_of_rd;
  testcase_t testcase;
  event event_a;
  ahb5_transaction trans;

  function new(mailbox gen2drv, int no_of_wr, int no_of_rd, testcase_t testcase, event event_a);
     this.gen2drv = gen2drv;
     this.testcase = testcase;
     this.no_of_wr = no_of_wr;
     this.no_of_rd = no_of_rd;
     this.event_a = event_a;
  endfunction

  task main();
    repeat(5) begin
      trans = new();
      trans.randomize();
      trans.display("generator");

      gen2drv.put(trans);
      @(event_a);
    end
  endtask
endclass
