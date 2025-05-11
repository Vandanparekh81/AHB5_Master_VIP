//Monitor sample all the data from interface and send to scoreboard using mailbox
class AT_ahb5_monitor_c;
  //Declarations of ahb5_monitor signals
  mailbox AT_mon2scb_m; //Mailbox For Monitor and Scoreboard component
  int AT_trans_count_i = 0; //Transaction Count
  logic AT_curr_write_l; //siganl that sample cuurent Hwrite value
  logic [ADDR_WIDTH-1 : 0] AT_curr_addr_l; //signal that store current address
  logic AT_next_write_l; //siganl that sample next Hwrite value  
  int AT_wr_trans_count_i = 0; //Write Transaction Count
  int AT_rd_trans_count_i = 0; //Read Transaction Count
  logic [ADDR_WIDTH-1 : 0] AT_next_addr_l; //signal that store next address 
  virtual AT_ahb5_interface_i intf; //Interface instance

  //Constructor of monitor 
  function new(mailbox AT_mon2scb_m, virtual AT_ahb5_interface_i intf); 
          this.AT_mon2scb_m = AT_mon2scb_m;
          this.intf = intf;
  endfunction

  // Main task of monitor, Moitor sample data, address and other control signals and send to scoreboard using mailbox
  task AT_main_t();
    forever begin
      fork 
        begin // Thread 1 , In this thread monitor processes are happen      
          if(intf.AT_HResetn_l) begin // Reset Condition 
            AT_ahb5_transaction_c trans; //Transaction class instance
            trans = new(); 
            if(AT_trans_count_i == 0) begin // For first transaction it sample all signals on negedge of clock
              @(negedge intf.AT_Hclk_l);
              AT_curr_write_l = intf.AT_Hwrite_l;
              AT_curr_addr_l = intf.AT_Haddr_l;
              trans.AT_Haddr_l = intf.AT_Haddr_l;
              trans.AT_Hwrite_l = intf.AT_Hwrite_l;
              trans.AT_Hready_l = intf.AT_Hready_l;
              trans.AT_Hburst_l = intf.AT_Hburst_l;
              trans.AT_Htrans_l = intf.AT_Htrans_l;
              trans.AT_Hsize_l = intf.AT_Hsize_l;
              trans.AT_Hresp_l = intf.AT_Hresp_l;
              trans.AT_Hsel_l = intf.AT_Hsel_l;
            end

            else begin // After first transaction it sample signal 
              AT_curr_write_l = AT_next_write_l;
              AT_curr_addr_l = AT_next_addr_l;
              trans.AT_Haddr_l = AT_next_addr_l;
              trans.AT_Hwrite_l = AT_next_write_l;
              trans.AT_Hready_l = intf.AT_Hready_l;
              trans.AT_Hburst_l = intf.AT_Hburst_l;
              trans.AT_Htrans_l = intf.AT_Htrans_l;
              trans.AT_Hsize_l = intf.AT_Hsize_l;
              trans.AT_Hresp_l = intf.AT_Hresp_l;
              trans.AT_Hsel_l = intf.AT_Hsel_l;      
            end
            @(negedge intf.AT_Hclk_l);
            //When curr_write == 1 then it sample wdata and sample next address and next write signal here and after send pakcet to scoreboard 
            if(AT_curr_write_l) begin 
              trans.AT_Hwdata_l = intf.AT_Hwdata_l; //sample write data from interface
              AT_next_addr_l = intf.AT_Haddr_l; //sample address from interface
              AT_next_write_l = intf.AT_Hwrite_l; //sample write or read signal from interface
              $display("Next addr = %0h | Next write = %0h ", AT_next_addr_l, AT_next_write_l);
              AT_trans_count_i++; //Incrememt in transaction count ;
              AT_wr_trans_count_i++; //Incrememt in write transaction count ;
              AT_mon2scb_m.put(trans); // put packet in mailbox
              trans.AT_display_t("Write Monitor"); //calling display task of transaction class for write transaction of monitor
            end

            //whem curr_write = 0 it indicate read operation so it sample read data and next address and next write and send packet to scoreboard through mailbox
            if(AT_curr_write_l == 0) begin 
              @(posedge intf.AT_Hclk_l);
              trans.AT_Hrdata_l = intf.AT_Hrdata_l; //sample read data from interface
              AT_next_addr_l = intf.AT_Haddr_l; //sample address from interface
              AT_next_write_l = intf.AT_Hwrite_l; //sample write or read signal from interface
              $display("Next addr = %0h | Next write = %0h ", AT_next_addr_l, AT_next_write_l);
              AT_trans_count_i++; //Incrememt in transaction count
              AT_rd_trans_count_i++; //Increment in read transaction count
              AT_mon2scb_m.put(trans); //put packet in mailbox
              trans.AT_display_t("Read Monitor"); //calling display task of transaction class for write transaction of monitor  
            end
          end
        end // Thread 1 ended
        begin //Thread 2 
          //When HResetn is equal to zero then it wait until HResetn become 1
          if(intf.AT_HResetn_l == 0) begin 
            wait(intf.AT_HResetn_l);
          end
        end   //Thread 2 ended
      join
    end
  endtask
endclass      
