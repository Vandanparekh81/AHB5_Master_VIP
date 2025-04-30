import ahb5_pkg::*;
class ahb5_slave_dummy_driver;
  logic [DATA_WIDTH-1:0] Hrdata;
  logic Hresp;
  logic Hready;
  logic [DATA_WIDTH-1:0] mem [*];
  ahb5_transaction trans;
  virtual ahb5_interface intf;


  function new(virtual ahb5_interface intf);
    this.intf = intf;
  endfunction

  task main();
    Hready = 1;
    forever begin
      $display("11-------------------------------------------------------------------------------");
      $display("---------------------------------------------------------------------------------");
      $display("Time = %0t, intf.Hwrite = %0d, intf.Hready = %0d", $time,intf.Hwrite,intf.Hready);
      $display("---------------------------------------------------------------------------------");
      $display("---------------------------------------------------------------------------------");
      @(posedge intf.Hclk);
      intf.Hready <= Hready;
      $display("22-------------------------------------------------------------------------------");
      $display("---------------------------------------------------------------------------------");
      $display("Time = %0t, intf.Hwrite = %0d, intf.Hready = %0d", $time,intf.Hwrite,intf.Hready);
      $display("---------------------------------------------------------------------------------");
      $display("---------------------------------------------------------------------------------");

      @(posedge intf.Hclk);
      $display("33-------------------------------------------------------------------------------");
      $display("---------------------------------------------------------------------------------");
      $display("Time = %0t, intf.Hwrite = %0d, intf.Hready = %0d", $time,intf.Hwrite,intf.Hready);
      $display("---------------------------------------------------------------------------------");
      $display("---------------------------------------------------------------------------------");
      //if(intf.Hwrite == 1 && intf.Hready == 1 && intf.Htrans != 0) begin
      if(intf.Hwrite == 1 && intf.Hready == 1) begin
        @(intf.Hwdata);
        mem[intf.Haddr] = intf.Hwdata;
        intf.Hresp = 0;
        $display("---------------------------------------------------------------------------------");
        $display("WRITE OPERATION INSIDE SLAVE DUMMY DRIVER TIme = %0t | memory = %0h | memory without address = %p | At slave dummy Haddr = %0h | At slave dummy decimal Haddr = %0d", $time, mem[intf.Haddr], mem, intf.Haddr, intf.Haddr);
        $display("---------------------------------------------------------------------------------");
      end

      //if(intf.Hwrite == 0 && intf.Hready == 0 && intf.Htrans != 0) begin
      $display("---------------------------------------------------------------------------------");
      $display("---------------------------------------------------------------------------------");
      $display("Time = %0t, intf.Hwrite = %0d, intf.Hready = %0d", $time,intf.Hwrite,intf.Hready);
      $display("---------------------------------------------------------------------------------");
      $display("---------------------------------------------------------------------------------");
      if(intf.Hwrite == 0 && intf.Hready == 1) begin
        @(posedge intf.Hclk);
        intf.Hrdata <= mem[intf.Haddr];
        intf.Hresp = 0;
        $display("---------------------------------------------------------------------------------");
        $display("READ OPERATION INSIDE SLAVE DUMMY DRIVER TIme = %0t | intf.Hrdata = %0h | memory = %0h | memory without address = %p | At slave dummy Haddr = %0h | At slave dummy decimal Haddr = %0d", $time, intf.Hrdata, mem[intf.Haddr], mem, intf.Haddr, intf.Haddr);
        $display("---------------------------------------------------------------------------------");
        $display("Time = %0t | intf.Hrdata = %0h", $time,intf.Hrdata);
      end
      if(intf.Hresp == 0)
              intf.Hready = 1;
    end
  endtask
endclass
