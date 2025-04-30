import ahb5_pkg::*;
class ahb5_driver;
  mailbox gen2drv;
  virtual ahb5_interface.ahb5_driver intf;

  function new(mailbox gen2drv, virtual ahb5_interface.ahb5_driver intf);
    this.gen2drv = gen2drv;
    this.intf = intf;
  endfunction

  task reset();
    intf.cb_master.Hwdata <= 0;
    intf.cb_master.Haddr <= 0;
    intf.cb_master.Htrans <= 0;
    intf.cb_master.Hburst <= 0;
    intf.cb_master.Hwrite <= 0;
    intf.cb_master.Hsize <= 0;
    intf.cb_master.Hsel <= 0;
    $display("Reset is initiated so all the value is passing zero");
    @(posedge intf.Hclk);
  endtask

    

  task main();

    forever begin
      ahb5_transaction trans;
           gen2drv.get(trans);
      fork
        @(posedge intf.Hclk);
        begin

          if(intf.HResetn) begin
            //intf.cb_master.Hwdata <= trans.Hwdata;
            intf.cb_master.Haddr <= trans.Haddr;
            intf.cb_master.Htrans <= trans.Htrans;
            intf.cb_master.Hwrite <= trans.Hwrite;
            intf.cb_master.Hsize <= trans.Hsize;
            intf.cb_master.Hsel <= trans.Hsel;
            intf.cb_master.Hburst <= trans.Hburst;
            $display("Time = %0t Hello",$time);
          end
          //do 
            //@(intf.cb_master);
          //while(!intf.cb_master.Hready);
          //$display("Time = %0t Hello22",$time);
        end
        begin
          @(posedge intf.Hclk);
          if(trans.Hwrite) begin
            @(posedge intf.Hclk);
            while(!intf.cb_master.Hready) @(posedge intf.Hclk);
            if(intf.cb_master.Hready) begin
              intf.cb_master.Hwdata <= trans.Hwdata;
              $display("222 Time = %0t | intf.cb_master.Hwdata = %0h", $time, intf.cb_master.Hwdata);
            end
          end
          trans.display("driver");
        end
      join

    end
  endtask
endclass
