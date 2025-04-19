
class ahb5_monitor;
  mailbox mon2scb;
  event event_a;
  virtual ahb5_interface.ahb5_monitor intf;


  function new(mailbox mon2scb, virtual ahb5_interface.ahb5_monitor intf, event event_a);
          this.mon2scb = mon2scb;
          this.intf = intf;
          this.event_a = event_a;
  endfunction


  task main();
    forever begin
      ahb5_transaction trans;
      trans = new();
      //$display("Time = %0t Hemlooo", $time);
      @(intf.cb_monitor);
      //$display("Time = %0t Hemlooo 322", $time);
      trans.Hwdata = intf.cb_monitor.Hwdata;
      //$display("Time = %0t Hemlooo 422", $time);
      trans.Haddr = intf.cb_monitor.Haddr;
      //$display("Time = %0t Hemlooo 522", $time);
      trans.Hrdata = intf.cb_monitor.Hrdata;
      //$display("Time = %0t Hemlooo 622", $time);
      trans.Htrans = intf.cb_monitor.Htrans;
      //$display("Time = %0t Hemlooo 722", $time);
      trans.Hwrite = intf.cb_monitor.Hwrite;
      //$display("Time = %0t Hemlooo 822", $time);
      trans.Hsize = intf.cb_monitor.Hsize;
      //$display("Time = %0t Hemlooo 922", $time);
      trans.Hburst = intf.cb_monitor.Hburst;
      //$display("Time = %0t Hemlooo 1122", $time);
      trans.Hresp = intf.cb_monitor.Hresp;
      //$display("Time = %0t Hemlooo 1222", $time);
      trans.Hsel = intf.cb_monitor.Hsel;
      //$display("Time = %0t Hemlooo 1322", $time);
      trans.Hready = intf.cb_monitor.Hready;
      //$display("Time = %0t Hemlooo 1422", $time);
      trans.display("Monitor");
      mon2scb.put(trans);
      //$display("Time = %0t Hemlooo 1522", $time);
      ->event_a; 
      end
  endtask
endclass      
