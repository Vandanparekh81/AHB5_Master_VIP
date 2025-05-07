import ahb5_pkg::*;
class ahb5_monitor;
  mailbox mon2scb;
  event event_a;
  //virtual ahb5_interface.ahb5_monitor intf;
  virtual ahb5_interface intf;


  /*function new(mailbox mon2scb, virtual ahb5_interface.ahb5_monitor intf, event event_a);
          this.mon2scb = mon2scb;
          this.intf = intf;
          this.event_a = event_a;
  endfunction*/

  function new(mailbox mon2scb, virtual ahb5_interface intf, event event_a);
          this.mon2scb = mon2scb;
          this.intf = intf;
          this.event_a = event_a;
  endfunction

  task main();
    forever begin
      ahb5_transaction trans;
      trans = new();
      $display("Time = %0t debugging display", $time);
      //@(posedge intf.Hclk);
      @(negedge intf.Hclk);
      trans.Haddr = intf.Haddr;
      $display("Time = %0t debugging display 622", $time);
      trans.Htrans = intf.Htrans;
      $display("Time = %0t debugging display 722", $time);
      trans.Hwrite = intf.Hwrite;
      $display("Time = %0t debugging display 822", $time);
      trans.Hsize = intf.Hsize;
      $display("Time = %0t debugging display 922", $time);
      trans.Hburst = intf.Hburst;
      $display("Time = %0t debugging display 1122", $time);
      trans.Hresp = intf.Hresp;
      $display("Time = %0t debugging display 1222", $time);
      trans.Hsel = intf.Hsel;
      $display("Time = %0t debugging display 1322", $time);
      trans.Hready = intf.Hready;
      $display("Time = %0t debugging display 1422", $time);
      if(intf.Hwrite == 1) begin
        $display("Time = %0t debugging display 1522", $time);
        @(negedge intf.Hclk);
        trans.Hwdata = intf.Hwdata;
        trans.display("Write Monitor");
      end
      else begin 
        $display("Time = %0t debugging display 1622", $time);
        @(negedge intf.Hclk);
        trans.Hrdata = intf.Hrdata;
        trans.display("Read Monitor");
      end
      $display("[%0t] Debugging Display 111 of Monitor ", $time);
      trans.display("Outside Monitor");
      $display("[%0t] Debugging Display 222 of Monitor ", $time);
      mon2scb.put(trans);
      $display("[%0t] Debugging Display 333 of Monitor ", $time);
      ->event_a; 
      $display("[%0t] Debugging Display 444 of Monitor ", $time);
      end
  endtask
endclass      
