class ahb5_driver;
  mailbox gen2drv;
  semaphore phase_synchro = new(0);
  //ahb5_configure cfg;
  virtual ahb5_interface.ahb5_driver intf;
  event reset_deasserted;
  //event phase_synchro;
  function new(mailbox gen2drv, virtual ahb5_interface.ahb5_driver intf, event reset_deasserted);
    this.gen2drv = gen2drv;
    this.intf = intf;
    this.reset_deasserted = reset_deasserted;
  endfunction

  task reset();
    intf.cb_master.Hwdata <= 0;
    intf.cb_master.Haddr <= 0;
    intf.cb_master.Htrans <= 0;
    intf.cb_master.Hburst <= 0;
    intf.cb_master.Hwrite <= 0;
    intf.cb_master.Hsize <= 0;
    intf.cb_master.Hsel <= 0;
    //intf.cb_master.Hready <= 0;
    //intf.cb_master.Hrdata <= 0;
  endtask
  task main();
    forever begin
      if(!intf.HResetn) begin
        reset();
        $display("[%0t] Reset is initiated so all signals goes to zero", $time);
        wait(intf.HResetn);
        $display("[%0t] Event triggered", $time);
        ->reset_deasserted;
      end
      else begin
        ahb5_transaction trans;
        fork
          //addr phase 
          begin //thread 1
            $display("Time = %0t Debugging display 12", $time);
            while(intf.HResetn) begin
              $display("Time = %0t Debugging display 12", $time);
              gen2drv.get(trans);
              @(posedge intf.Hclk);
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
              if(trans.Hwrite) begin
                phase_synchro.put(1);
                $display("Put 1 Key In Semaphore");
              end    
            end
          end

          //data phase
          begin // Thread 2 Is started
            while(intf.HResetn) begin
            phase_synchro.get(1);
            //@(posedge intf.Hclk);
            $display("Time = %0t Debugging display 22", $time); //First Posedge 5ns
            //if(trans.Hwrite) begin
            $display("Time = %0t Debugging display 23", $time); //First Posedge 5ns
              @(posedge intf.Hclk);
              intf.cb_master.Hwdata <= trans.Hwdata;
              $display("Time = %0t Debugging display 24", $time); //Second Posedge 15ns
              @(negedge intf.Hclk);
              while(!intf.cb_master.Hready) @(posedge intf.Hclk);
              $display("Time = %0t Debugging display 25", $time); //Second Posedge 15ns Currently when Hready is continously High
              //end //if(trans.Hwrite) conditional statement end here 
            trans.display("driver");
            end
          end // Thread 2 is ended
        join
      end
    end //Forever loop end
  endtask
endclass
