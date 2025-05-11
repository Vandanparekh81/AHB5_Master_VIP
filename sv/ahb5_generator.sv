//Generator class generate data according to AT_testcase_te and send that generated data to ahb5_driver using mailbox  
class AT_ahb5_generator_c;
  //Declarations of generator class signals
  mailbox AT_gen2drv_m; // Mailbox between generator and driver
  //ahb5_configure cfg;
  int AT_no_of_wr_i; // No of write transactions
  int AT_no_of_rd_i; //No of read transactions
  int AT_no_of_random_i; //No of Random read and write transactions
  testcase_t AT_testcase_te; // Testcase 
  AT_ahb5_transaction_c trans; //Transaction class instance
  event AT_reset_deasserted_e; // synchronization between generator and driver for reset condition

  //Constructor of Generator class
  function new(mailbox AT_gen2drv_m, int AT_no_of_wr_i, int AT_no_of_rd_i, int AT_no_of_random_i, testcase_t AT_testcase_te, event AT_reset_deasserted_e);
     this.AT_gen2drv_m = AT_gen2drv_m;
     this.AT_testcase_te = AT_testcase_te;
     this.AT_no_of_wr_i = AT_no_of_wr_i;
     this.AT_no_of_rd_i = AT_no_of_rd_i;
     this.AT_no_of_random_i = AT_no_of_random_i;
     this.AT_reset_deasserted_e = AT_reset_deasserted_e;
  endfunction
  
  //Common Testcase Body For SANITY, DIRECTED, RANDOM
  //int no_of_tr = for write operation how many write operation you want to perform 
  //bit random = you want to randomize AT_Hwrite_l For RANDOM_TESTCASE
  //string test_name = this variable for AT_display_t function for our understanding 
  //string test_name = let's assume you perform DIRECTED then how you know for that you have to pass AT_testcase_te name in place of z when you call task
  task AT_testcase_body_t(int no_of_tr, bit wr_rd, bit random, string test_name);
    repeat(no_of_tr) begin
      if(random == 0) begin
        trans.AT_Hwrite_l = wr_rd;
      end

      else begin
        trans.AT_Hwrite_l = $urandom_range(0,1);
      end
      if(!trans.randomize()) $fatal("AHB5_Generator Randomization Failed");
      AT_gen2drv_m.put(trans);
      trans.AT_display_t(test_name);
      #10;
    end
  endtask

//Generator Main task that basically select statement according to testcase
  task AT_main_t();
    trans = new();
      wait(AT_reset_deasserted_e.triggered); // When reset is High then generator start to generate 
      case(AT_testcase_te) 
        DIRECTED_TESTCASE: begin
          AT_testcase_body_t(AT_no_of_wr_i, 1, 0, "Directed Write case in Generator"); // For Write
          AT_testcase_body_t(AT_no_of_rd_i, 0, 0, "Directed Read case in Generator"); // For Read
        end
        SANITY_TESTCASE: begin
          AT_testcase_body_t(1, 1, 0, "Sanity Write Testcase"); // For Write
          AT_testcase_body_t(1, 0, 0, "Sanity Read Testcase"); // For Read
        end
        RANDOM_TESTCASE: begin
          AT_testcase_body_t(AT_no_of_random_i, 0, 1, "Random Testcase"); // For random Read and Write  
        end
      endcase
  endtask
endclass
