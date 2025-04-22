class ahb5_slave_dummy_driver;
  logic [31:0] Hrdata;
  logic Hresp;
  logic Hready;
  logic [31:0] mem [*];
  ahb5_transaction trans;
  virtual ahb5_interface intf;


  function new(virtual ahb5_interface intf);
    this.intf = intf;
  endfunction

  task main();
    Hready = 1;
    forever begin
      @(posedge intf.Hclk);
      intf.Hready <= Hready;

      @(posedge intf.Hclk);
      if(intf.Hwrite == 1 && intf.Hready == 1 && intf.Htrans != 0) begin
        mem[intf.Haddr] = intf.Hwdata;
        intf.Hresp = 0;
      end

      if(intf.Hwrite == 0 && intf.Hready == 0 && intf.Htrans != 0) begin
        intf.Hrdata <= mem[intf.Haddr];
        intf.Hresp =  0;
      end
      if(intf.Hresp == 0)
              intf.Hready = 1;
    end
  endtask
endclass
