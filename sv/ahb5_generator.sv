class ahb5_generator;
  mailbox gen2drv;
  int no_of_tr;
  event event_a;
  ahb5_transaction trans;

  function new(mailbox gen2drv, int no_of_tr, event event_a);
     this.gen2drv = gen2drv;
     this.no_of_tr = no_of_tr;
     this.event_a = event_a;
  endfunction

  task main();
    repeat(no_of_tr) begin
      trans = new();
      trans.randomize();
      trans.display("generator");

      gen2drv.put(trans);
      @(event_a);
    end
  endtask
endclass
