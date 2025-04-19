class ahb5_driver;
  mailbox gen2drv;
  virtual ahb5_interface.ahb5_driver intf;

  function new(mailbox gen2drv, virtual ahb5_interface.ahb5_driver intf);
    this.gen2drv = gen2drv;
    this.intf = intf;
  endfunction

  task main();

    forever begin
      ahb5_transaction trans;
      @(intf.cb_master);
      gen2drv.get(trans);
      trans.display("driver");

      /*if(intf.HResetn == 0) begin
      intf.Hwdata <= 0;
      intf.Haddr <= 0;
      intf.Htrans <= 0;
      intf.Hburst <= 0;
      intf.Hwrite <= 0;
      intf.Hsize <= 0;
      intf.Hsel <= 0;
      $display("Reset is initiated so all the value is passing zero");
      trans.display("Driver");
      end
      else begin*/
      intf.cb_master.Hwdata <= trans.Hwdata;
      intf.cb_master.Haddr <= trans.Haddr;
      intf.cb_master.Htrans <= trans.Htrans;
      intf.cb_master.Hwrite <= trans.Hwrite;
      intf.cb_master.Hsize <= trans.Hsize;
      intf.cb_master.Hsel <= trans.Hsel;
      intf.cb_master.Hburst <= trans.Hburst;
      //end

    end
  endtask
endclass
