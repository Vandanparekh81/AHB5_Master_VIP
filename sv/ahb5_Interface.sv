interface ahb5_interface #(parameter DATA_WIDTH = 32, parameter ADDR_WIDTH = 32) // Support 8 to 1024 bitts
  (
    input logic Hclk,
    input logic HResetn
  );

  logic [DATA_WIDTH-1 : 0] Hwdata;
  logic [ADDR_WIDTH-1 : 0] Haddr;
  logic [DATA_WIDTH-1 : 0] Hrdata;
  logic [1:0] Htrans;
  logic Hwrite;
  logic [2:0] Hsize;
  logic [2:0] Hburst;
  logic Hready; 
  logic Hresp;
  logic Hsel;
  clocking cb_master @(posedge Hclk);
    output Haddr, Hwrite, Hsize, Hburst, Htrans, Hwdata,Hsel;
    input Hready, Hresp, Hrdata;
  endclocking
  clocking cb_monitor @(posedge Hclk);
    input Hready, Hresp, Hrdata, Haddr, Hwrite, Hsize, Hburst, Htrans, Hwdata, Hsel;
  endclocking

  // modport master (clocking cb_master, input HResetn, Hclk);
  modport ahb5_driver (clocking cb_master, input HResetn, Hclk);
  modport ahb5_monitor(clocking cb_monitor, input HResetn, Hclk);

endinterface
