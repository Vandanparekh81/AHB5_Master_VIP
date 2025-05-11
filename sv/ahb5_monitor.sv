class ahb5_monitor;
  mailbox mon2scb; //Mailbox For Monitor and Scoreboard component
  event event_a; 
  int trans_count = 0;
  logic curr_write; 
  logic [ADDR_WIDTH-1 : 0] curr_addr;
  logic next_write; 
  int wr_trans_count = 0;
  int rd_trans_count = 0;
  logic [ADDR_WIDTH-1 : 0] next_addr;
  virtual ahb5_interface intf; //Interface

  //Constructor of monitor 
  function new(mailbox mon2scb, virtual ahb5_interface intf, event event_a); 
          this.mon2scb = mon2scb;
          this.intf = intf;
          this.event_a = event_a;
  endfunction

  // Main task of monitor
  task main();
    forever begin
      //$display("Time = %0t debugging display 1522", $time);
      if(intf.HResetn) begin // Reset Condition 
        ahb5_transaction trans;
        trans = new();
        if(trans_count == 0) begin
          @(negedge intf.Hclk);
          curr_write = intf.Hwrite;
          curr_addr = intf.Haddr;
          trans.Haddr = intf.Haddr;
          trans.Hwrite = intf.Hwrite;
          trans.Hready = intf.Hready;
          trans.Hburst = intf.Hburst;
          trans.Htrans = intf.Htrans;
          trans.Hsize = intf.Hsize;
          trans.Hresp = intf.Hresp;
          trans.Hsel = intf.Hsel;
        end

        else begin
          curr_write = next_write;
          curr_addr = next_addr;
          trans.Haddr = next_addr;
          trans.Hwrite = next_write;
          trans.Hready = intf.Hready;
          trans.Hburst = intf.Hburst;
          trans.Htrans = intf.Htrans;
          trans.Hsize = intf.Hsize;
          trans.Hresp = intf.Hresp;
          trans.Hsel = intf.Hsel;      
        end
        @(negedge intf.Hclk);
        if(curr_write) begin
          trans.Hwdata = intf.Hwdata;
          next_addr = intf.Haddr;
          next_write = intf.Hwrite;
          $display("Next addr = %0h | Next write = %0h ", next_addr, next_write);
          trans_count++;
          wr_trans_count++;
          mon2scb.put(trans);
          trans.display("Write Monitor");
        end
        if(curr_write == 0) begin
          @(posedge intf.Hclk);
          trans.Hrdata = intf.Hrdata;
          next_addr = intf.Haddr;
          next_write = intf.Hwrite;
          $display("Next addr = %0h | Next write = %0h ", next_addr, next_write);
          trans_count++;
          rd_trans_count++;
          mon2scb.put(trans);
          trans.display("Read Monitor");
        end
      end
      else begin
        wait(intf.HResetn);
      end
    end
  endtask
endclass      
