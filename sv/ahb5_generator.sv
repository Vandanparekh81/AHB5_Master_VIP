import ahb5_pkg::*;
class ahb5_generator;
  mailbox gen2drv;
  int no_of_wr;
  int no_of_rd;
  int no_of_random;
  testcase_t testcase;
  event event_a;
  ahb5_transaction trans;


  function new(mailbox gen2drv, int no_of_wr, int no_of_rd, int no_of_random, testcase_t testcase, event event_a);
     this.gen2drv = gen2drv;
     this.testcase = testcase;
     this.no_of_wr = no_of_wr;
     this.no_of_rd = no_of_rd;
     this.no_of_random = no_of_random;

     this.event_a = event_a;
  endfunction
  
  //Common Testcase Body For SANITY, DIRECTED, RANDOM
  //int no_of_tr = for write operation how many write operation you want to perform 
  //bit random = you want to randomize Hwrite For RANDOM_TESTCASE
  //string test_name = this variable for display function for our understanding 
  //string test_name = let's assume you perform DIRECTED then how you know for that you have to pass testcase name in place of z when you call task
  task testcase_body(int no_of_tr, bit wr_rd, bit random, string test_name );
    repeat(no_of_tr) begin
      if(random == 0) begin
        trans.Hwrite = wr_rd;
      end

      else begin
        trans.Hwrite = $urandom_range(0,1);
      end
      trans.randomize();
      gen2drv.put(trans);
      $display("[%0t] Debugging Display 111 of Generator ", $time);
      trans.display(test_name);
      $display("[%0t] Debugging Display 222 of Generator ", $time);
      #20;
      $display("[%0t] Debugging Display 333 of Generator ", $time);
    end
  endtask

  task main();
    trans = new();
    case(testcase) 
      DIRECTED_TESTCASE: begin
        testcase_body(no_of_wr, 1, 0, "Directed Write case in Generator");
        testcase_body(no_of_rd, 0, 0, "Directed Read case in Generator");
      end
      SANITY_TESTCASE: begin
        testcase_body(1, 1, 0, "Sanity Write Testcase");
        testcase_body(1, 0, 0, "Sanity Read Testcase");
      end
      RANDOM_TESTCASE:  begin
        testcase_body(no_of_random, 0, 1, "Random Testcase");  
      end
    endcase
      
  endtask
endclass
