//Scoreboard take data from monitor through mailbox and verify it and if it is correct them it increase pass_count and display testcase passed and if it is incorrect then it increase fail_count and give error for that transaction
class AT_ahb5_scoreboard_c;
   //Declarations of Scoreboard signals
   mailbox AT_mon2scb_m; // Mailbox that take data from monitor
   bit [DATA_WIDTH-1:0] AT_mem_b [*]; // Dummy memory to store write data and address as a index
   int AT_trans_count_i = 0; //Transaction count
   int AT_wr_trans_count_i = 0; //Write transaction count
   int AT_rd_trans_count_i = 0; //Read transaction count
   int AT_pass_count_i = 0; //Transaction pass count
   int AT_fail_count_i = 0; //Transaction fail count
   testcase_t AT_testcase_te; //Testcase

   //Constructor for Mailbox
   function new(mailbox AT_mon2scb_m, testcase_t AT_testcase_te);
     this.AT_mon2scb_m = AT_mon2scb_m;
     this.AT_testcase_te = AT_testcase_te;
   endfunction

   //Main task of Scoreboard, Main task store address as a index and data as a element when trans.write = 1 and compare data when trans.write = 0
   task AT_main_t();
     forever begin
        AT_ahb5_transaction_c trans; //Transaction class instance
       trans = new();
       AT_mon2scb_m.get(trans); //Get data from monitor through mailbox
       AT_trans_count_i++; //Increment in transaction count

       //When trans.write = 1 then it store data and address in dummy memory
       if(trans.AT_Hwrite_l == 1) begin
         AT_mem_b[trans.AT_Haddr_l] = trans.AT_Hwdata_l; // Storing address as a index and write data as a element
         $display("Memory is Filled with AT_Hwdata_l");
         AT_wr_trans_count_i++; //Increment in write count

       end

       //When trans.write = 0 then it compare trans.rdata with dummy memory data
       if(trans.AT_Hwrite_l == 0) begin
         AT_rd_trans_count_i++; //Increment in read coun
         //If data is correct then testcase is passed
         if(AT_mem_b[trans.AT_Haddr_l] == trans.AT_Hrdata_l) begin
           AT_pass_count_i++; // Increment in pass_count
           $display("%s IS PASSED", AT_testcase_te);
         end

         //If data is incorrect then it give error
         else begin
           $error("%s IS FAILED", AT_testcase_te);
           AT_fail_count_i++; //Increment in fail_count
         end
       end
       trans.AT_display_t("Scoreboard Classs"); // Calling display taslk of transaction class for scoreboard
       $display("Total pass count = %0d", AT_pass_count_i);
       $display("Total fail count = %0d", AT_fail_count_i);
       $display("Total write count = %0d", AT_wr_trans_count_i);
       $display("Total read count = %0d", AT_rd_trans_count_i);
       $display("Total transaction count = %0d", AT_trans_count_i);

     end      
   endtask
endclass

