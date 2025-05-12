import AT_ahb5_pkg_p::*;

//Top module include test, interface and global signals and pass global signals to interface 
module AT_ahb5_top_m;
  //Declaration of global signals and test instance and interface instance
  logic AT_Hclk_l, AT_HResetn_l; //Global Signals
  AT_ahb5_interface_i intf(AT_Hclk_l, AT_HResetn_l); //Passing global signals to interface
  AT_ahb5_test_p tst(intf); //passing interface to test
  initial forever #5 AT_Hclk_l = ~AT_Hclk_l; //Driving the clock 

//Driving global signals
  initial begin 
    AT_Hclk_l = 0;
    AT_HResetn_l = 0;
    $display("[%0t] Reset is Initiated",$time);
    #10 AT_HResetn_l = 1;
    $display("[%0t] Reset is Deasserted",$time);
  end
endmodule
