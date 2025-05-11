class ahb5_slave_dummy_driver;
  logic [DATA_WIDTH-1:0] Hrdata;
  logic Hresp;
  logic Hready;
  bit [DATA_WIDTH-1:0] mem [*];
  ahb5_transaction trans;
  virtual ahb5_interface intf;
  //logic [ADDR_WIDTH-1:0] curr_wr_addr[$];
  //logic [DATA_WIDTH-1:0] curr_wr_data[$];
  logic [ADDR_WIDTH-1 : 0] curr_addr;
  logic [ADDR_WIDTH-1 : 0] next_addr;
  logic curr_write;
  logic next_write;


  int trans_count = 0;
  int wr_trans_count = 0;
  int rd_trans_count = 0;



  function new(virtual ahb5_interface intf);
    this.intf = intf;
  endfunction

  task main();
    forever begin
      if(intf.HResetn) begin
        fork
          begin
            $display("[%0t] when reset become 1 then slave driver is activated",$time);      
            intf.Hready <= 1;
            #25 intf.Hready = 0;
            #20 intf.Hready = 1;
          end
          begin
            if(trans_count == 0) begin
              @(negedge intf.Hclk);
              curr_addr = intf.Haddr;
              curr_write  = intf.Hwrite;
            end
            else begin
              curr_addr = next_addr;
              curr_write = next_write;
              $display("Current WRrite = %0d", curr_write);
            end
            @(negedge intf.Hclk);
            if(curr_write == 1) begin
                    mem[curr_addr] = intf.Hwdata;
                    next_addr = intf.Haddr;
                    next_write = intf.Hwrite;
                    $display("-------------------------------");
                    $display("Write operation on slave dummy | Time = %0t | Next write = %0d | current Write = %0d| memory = %p | memory[%0h] = %0h | in Decimal memory[%0d] = %0d", $time, next_write,  curr_write, mem,curr_addr,intf.Hwdata,curr_addr,intf.Hwdata);
                    $display("-------------------------------");
                    trans_count++;
                    wr_trans_count++;

                    $display("Time = %0t | total transaction count = %0d", $time,trans_count);
            end
            if(curr_write == 0) begin
                    intf.Hrdata <= mem[curr_addr];
                    next_addr = intf.Haddr;
                    next_write = intf.Hwrite;
                    trans_count++;
                    $display("Time = %0t | total transaction count = %0d", $time,trans_count);
                    $display("Read operation on slave dummy | Time = %0t | curr_addr = %0d in decimal | curr_addr = %0h in hexadecimal | read_data = %0d in decimal | read_data = %0h in Hexadecimal", $time, curr_addr,curr_addr,mem[curr_addr],mem[curr_addr]);

            end
          end
        join
      end
      else begin
        intf.Hready <= 0;
        intf.Hrdata <= 0;
        intf.Hresp <= 0;
        wait(intf.HResetn);
      end  
    end
  endtask
endclass
