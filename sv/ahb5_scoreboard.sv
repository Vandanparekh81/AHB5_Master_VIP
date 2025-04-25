import ahb5_pkg::*;
class ahb5_scoreboard;
        mailbox mon2scb;

        function new(mailbox mon2scb);
                this.mon2scb = mon2scb;
        endfunction

        task main();
          forever begin
            ahb5_transaction trans;

            trans = new();
            mon2scb.get(trans);
          end      
        endtask
endclass

