class ahb5_scoreboard;
   mailbox mon2scb;
   bit [DATA_WIDTH-1:0] mem [*];
   int trans_count = 0;
   int wr_trans_count = 0;
   int rd_trans_count = 0;
   int pass_count = 0;
   int fail_count = 0;
   testcase_t testcase;
   function new(mailbox mon2scb, testcase_t testcase);
     this.mon2scb = mon2scb;
     this.testcase = testcase;
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
         wr_trans_count++;

       end
       if(trans.Hwrite == 0) begin
         rd_trans_count++;
         if(mem[trans.Haddr] == trans.Hrdata) begin
           pass_count++;
           $display("%s IS PASSED", testcase);
         end
         else begin
           $error("%s IS FAILED", testcase);
           fail_count++;
         end
       end
       trans.display("Scoreboard Classs");
       $display("Total pass count = %0d", pass_count);
       $display("Total fail count = %0d", fail_count);
       $display("Total write count = %0d", wr_trans_count);
       $display("Total read count = %0d", rd_trans_count);
       $display("Total transaction count = %0d", trans_count);

     end      
   endtask
endclass

