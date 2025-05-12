//Slave dummy driver saves address and hwdata in memory during write operation and when read operation happens then it take data of Haddr from memory and give to intf.Hrdata

class AT_ahb5_slave_dummy_driver_c;

  //Declarations of ahb5_slave_dummy_driver_signals
  bit [DATA_WIDTH-1:0] AT_mem_b [*]; //Associative array for storing address and data
  virtual AT_ahb5_interface_i intf; //Interface instance
  logic [ADDR_WIDTH-1 : 0] AT_curr_addr_l; // signal that store current address
  logic [ADDR_WIDTH-1 : 0] AT_next_addr_l; // signal that store next address
  logic AT_curr_write_l; //signal that store current value of Hwrite signal
  logic AT_next_write_l; //signal that store next value of Hwrite signal 
  int AT_trans_count_i = 0; //Transaction count
  int AT_wr_trans_count_i = 0; //Write Transaction count
  int AT_rd_trans_count_i = 0; //Read Transaction count
 
  //Constructor of ahb5_slave_dummy_driver
  function new(virtual AT_ahb5_interface_i intf);
    this.intf = intf;
  endfunction

  //Main task, In the main task slave_dummy_driver store address and data into associate array when Hwrite = 1 and take data from that associative array when Hwrite is low
  task AT_main_t(); 
    forever begin
      if(intf.AT_HResetn_l) begin // When HReset is high then execute the process
        fork

          begin // Thread 1 for driving Hready signal
            intf.AT_Hready_l <= 1; // drive hready signal
          end

          begin // Thread 2 that execute write and read process
            if(AT_trans_count_i == 0) begin //For first time it take current address and current write as a interface address and write on negedge of clock
              @(negedge intf.AT_Hclk_l);
              AT_curr_addr_l = intf.AT_Haddr_l; 
              AT_curr_write_l  = intf.AT_Hwrite_l;
            end
            else begin //after first time it take current address and current write as a next address and write
              AT_curr_addr_l = AT_next_addr_l;
              AT_curr_write_l = AT_next_write_l;
              $display("Current WRrite = %0d", AT_curr_write_l);
            end
            @(negedge intf.AT_Hclk_l);
            if(AT_curr_write_l == 1) begin //When curr_write = 1 then it store address and data into associative array
                    AT_mem_b[AT_curr_addr_l] = intf.AT_Hwdata_l; 
                    AT_next_addr_l = intf.AT_Haddr_l; //Sample interface address
                    AT_next_write_l = intf.AT_Hwrite_l; //Sample interface write signal
                    $display("-------------------------------");
                    $display("Write operation on slave dummy | Time = %0t | Next write = %0d | current Write = %0d| memory = %p | memory[%0h] = %0h | in Decimal memory[%0d] = %0d", $time, AT_next_write_l,  AT_curr_write_l, AT_mem_b,AT_curr_addr_l,intf.AT_Hwdata_l,AT_curr_addr_l,intf.AT_Hwdata_l);
                    $display("-------------------------------");
                    AT_trans_count_i++; //incremet in transaction count
                    AT_wr_trans_count_i++;  //Increment in write count

            end
            if(AT_curr_write_l == 0) begin //When curr_write = 0 then it take data form associative array and give to the interface
                    intf.AT_Hrdata_l <= AT_mem_b[AT_curr_addr_l];
                    AT_next_addr_l = intf.AT_Haddr_l;
                    AT_next_write_l = intf.AT_Hwrite_l;
                    AT_trans_count_i++; //Increment in transaction count
                    AT_rd_trans_count_i++;  //Increment in read count
                    $display("Read operation on slave dummy | Time = %0t | AT_curr_addr_l = %0d in decimal | AT_curr_addr_l = %0h in hexadecimal | read_data = %0d in decimal | read_data = %0h in Hexadecimal", $time, AT_curr_addr_l,AT_curr_addr_l,AT_mem_b[AT_curr_addr_l],AT_mem_b[AT_curr_addr_l]);
            end
          end
        join
      end
      else begin // When HReset is 0 then it assign 0 to Hready Hresp and Hrdata and also wait until HReset become high
        intf.AT_Hready_l <= 0;
        intf.AT_Hrdata_l <= 0;
        intf.AT_Hresp_l <= 0;
        wait(intf.AT_HResetn_l);
      end  
    end
  endtask
endclass
