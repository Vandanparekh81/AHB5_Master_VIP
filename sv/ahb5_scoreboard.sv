import ahb5_pkg::*;
class ahb5_scoreboard;
   mailbox mon2scb;
   logic [DATA_WIDTH-1:0] mem [*];
   int trans_count = 0;
   int pass_count = 0;
   int fail_count = 0;

   function new(mailbox mon2scb);
     this.mon2scb = mon2scb;
   endfunction

   task main();
     forever begin
       ahb5_transaction trans;
       trans = new();
       mon2scb.get(trans);
       trans_count++;
       if(trans.Hwrite == 1) begin
         mem[trans.Haddr] = trans.Hwdata;
         $display("Memory is Filled with Hwdata");
       end
       if(trans.Hwrite == 0) begin
         if(mem[trans.Haddr] == trans.Hrdata) begin
           pass_count++;
           $display("SANITY TESTCASE IS PASSED");
         end
         else begin
           $error("SANITY_TESTCASE IS FAILED");
           fail_count++;
         end
       end
       trans.display("Scoreboard Classs");
       $display("Total pass count = %0d", pass_count);
       $display("Total fail count = %0d", fail_count);
       $display("Total transaction count = %0d", trans_count);

     end      
   endtask
endclass

