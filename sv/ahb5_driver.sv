import ahb5_pkg::*;
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
           gen2drv.get(trans);
      fork
        //addr phase 
        begin
          $display("Time = %0t Debugging display 12", $time);
          if(intf.HResetn) begin
            //intf.cb_master.Hwdata <= trans.Hwdata;
            $display("Time = %0t Debugging display 14", $time);
            intf.cb_master.Haddr <= trans.Haddr;
            $display("Time = %0t Debugging display 15", $time);
            intf.cb_master.Htrans <= trans.Htrans;
            intf.cb_master.Hwrite <= trans.Hwrite;
            intf.cb_master.Hsize <= trans.Hsize;
            intf.cb_master.Hsel <= trans.Hsel;
            intf.cb_master.Hburst <= trans.Hburst;
            $display("Time = %0t Hello",$time);
          end
          else begin
            intf.cb_master.Hwdata <= 0;
            intf.cb_master.Haddr <= 0;
            intf.cb_master.Htrans <= 0;
            intf.cb_master.Hburst <= 0;
            intf.cb_master.Hwrite <= 0;
            intf.cb_master.Hsize <= 0;
            intf.cb_master.Hsel <= 0;
            $display("Reset is initiated so all the value is passing zero");
          end 
          //do 
            //@(intf.cb_master);
          //while(!intf.cb_master.Hready);
          //$display("Time = %0t Hello22",$time);
        end
        //data phase
        begin
          @(posedge intf.Hclk);
          $display("Time = %0t Debugging display 22", $time); //First Posedge 5ns
          if(trans.Hwrite) begin
          $display("Time = %0t Debugging display 23", $time); //First Posedge 5ns
            @(posedge intf.Hclk);
            intf.cb_master.Hwdata <= trans.Hwdata;
            $display("Time = %0t Debugging display 24", $time); //Second Posedge 15ns
            while(!intf.cb_master.Hready) @(posedge intf.Hclk);
            $display("Time = %0t Debugging display 25", $time); //Second Posedge 15ns Currently when Hready is continously High
          end
          trans.display("driver");
        end
      join

    end
  endtask
endclass
