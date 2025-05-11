import ahb5_pkg::*;

module ahb5_top;
  logic Hclk, HResetn;
  event_f event_finish;


  ahb5_interface intf(Hclk, HResetn);
  ahb5_test tst(intf);
  initial forever #5 Hclk = ~Hclk;


  initial begin 
    Hclk = 0;
    HResetn = 0;
    $display("[%0t] Reset is Initiated",$time);
    // HResetn = 1;
    #10 HResetn = 1;
    $display("[%0t] Reset is Deasserted",$time);
    // #50 HResetn = 0;
    $display("[%0t] Reset is Initiated",$time);
    #10 HResetn = 1;
    $display("[%0t] Reset is Deasserted",$time);
    //$dumpfile("AHB5_Wave.vcd");
    //$dumpvars(0,ahb5_top);
  end

  /*initial begin
    @(event_finish);
    $finish;
  end*/
endmodule
