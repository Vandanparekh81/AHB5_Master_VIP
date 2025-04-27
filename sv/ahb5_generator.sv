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

  task testcase_body(int x, bit j, bit k, string z);
    repeat(x) begin
      trans.Hwrite = $urandom_range(j,k);
      trans.randomize();
      gen2drv.put(trans);
      trans.display(z);
      #9;
    end
  endtask

  task main();
    trans = new();
    case(testcase) 
      DIRECTED_TESTCASE: begin
        testcase_body(no_of_wr, 1, 1, "Directed Write case in Generator");
        testcase_body(no_of_rd, 0, 0, "Directed Read case in Generator");
      end
      SANITY_TESTCASE: begin
        testcase_body(1, 1, 1, "Sanity Write Testcase");
        testcase_body(1, 0, 0, "Sanity Read Testcase");
      end
      RANDOM_TESTCASE:  begin
        testcase_body(no_of_random, 0, 1, "Random Testcase");  
      end
    endcase
      
  endtask
endclass
