// Driver class basically take data from generator using mailbox and send to interface and this all process happen when AT_HResetn_l is High otherwise it detect reset condition and do zero all the data
class AT_ahb5_driver_c;
  //Declarations of ahb5_driver signals
  mailbox AT_gen2drv_m; // Mailbox between Generator and driver
  semaphore AT_phase_synchro_s = new(0); // This semaphore is for pipeline logic 
  virtual AT_ahb5_interface_i.ahb5_driver intf; //Interface instance
  event AT_reset_deasserted_e; // this event do synchronization between generator and driver for AT_HResetn_l signal

  //Constructor of driver class
  function new(mailbox AT_gen2drv_m, virtual AT_ahb5_interface_i.ahb5_driver intf, event AT_reset_deasserted_e);
    this.AT_gen2drv_m = AT_gen2drv_m;
    this.intf = intf;
    this.AT_reset_deasserted_e = AT_reset_deasserted_e;
  endfunction

  //Reset task, When AT_HResetn_l signai is low using the reset task all the signal value is zero
  task AT_reset_t();
    intf.cb_master.AT_Hwdata_l <= 0;
    intf.cb_master.AT_Haddr_l <= 0;
    intf.cb_master.AT_Htrans_l <= 0;
    intf.cb_master.AT_Hburst_l <= 0;
    intf.cb_master.AT_Hwrite_l <= 0;
    intf.cb_master.AT_Hsize_l <= 0;
    intf.cb_master.AT_Hsel_l <= 0;
    //intf.cb_master.AT_Hready_l <= 0;
    //intf.cb_master.Hrdata <= 0;
  endtask

  //Main task of driver where all the process is happened like send address, control signals and data to interface and if reset goes low then also it detect it 
  task AT_main_t();
    forever begin
      if(!intf.AT_HResetn_l) begin // If HResetn = 0 then the reset task is called and wait until HResetn is equal to 1
        AT_reset_t(); // Reset task is called
        $display("[%0t] Reset is initiated so all signals goes to zero", $time);
        wait(intf.AT_HResetn_l); //Wait until reset go high
        ->AT_reset_deasserted_e; //Event is triggered when reset go high and then generator start to generate data
      end
      else begin //If HResetn = 1 then it is execute all the processes
        AT_ahb5_transaction_c trans;
        fork
          
          //address  phase 
          //in the address phase all the control signals and address send to interface at the positive edge of the clock
          begin //thread 1
            while(intf.AT_HResetn_l) begin // Execute when HResetn signal is equal to 1
              AT_gen2drv_m.get(trans); 
              @(posedge intf.AT_Hclk_l);
              intf.cb_master.AT_Haddr_l <= trans.AT_Haddr_l;
              intf.cb_master.AT_Htrans_l <= trans.AT_Htrans_l;
              intf.cb_master.AT_Hwrite_l <= trans.AT_Hwrite_l;
              intf.cb_master.AT_Hsize_l <= trans.AT_Hsize_l;
              intf.cb_master.AT_Hsel_l <= trans.AT_Hsel_l;
              intf.cb_master.AT_Hburst_l <= trans.AT_Hburst_l;
              if(trans.AT_Hwrite_l) begin //When Hwrite = 1 then it is send key to semaphore for pipeline purpose 
                AT_phase_synchro_s.put(1);
                $display("Put 1 Key In Semaphore");
              end    
            end
          end // thread 1 is ended

          //data phase
          //in the data phase data is send to interface
          begin // Thread 2 Is started
            while(intf.AT_HResetn_l) begin //HResetn equal to 1
            AT_phase_synchro_s.get(1); 
              @(posedge intf.AT_Hclk_l);
              intf.cb_master.AT_Hwdata_l <= trans.AT_Hwdata_l;
              @(negedge intf.AT_Hclk_l);
              while(!intf.cb_master.AT_Hready_l) @(posedge intf.AT_Hclk_l);
            trans.AT_display_t("driver");
            end
          end // Thread 2 is ended
        join
      end
    end //Forever loop end
  endtask
endclass
