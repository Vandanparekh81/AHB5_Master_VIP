//`include "../sv/ahb5_Interface.sv"
//`include "../sve/ahb5_test.sv"

import ahb5_pkg::*;

module ahb5_top;
  logic Hclk, HResetn;

  ahb5_interface intf(Hclk, HResetn);
  ahb5_test tst(intf);
  initial forever #5 Hclk = ~Hclk;


  initial begin 
    Hclk = 0;
    HResetn = 1;
    //#100 HResetn = 0;
    //$dumpfile("AHB5_Wave.vcd");
    //$dumpvars(0,ahb5_top);
    #55;
    $finish;
  end
endmodule
