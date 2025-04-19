class ahb5_transaction #(parameter DATA_WIDTH = 32, parameter ADDR_WIDTH = 32); //Support 8 to 1024 bits 
  rand logic [DATA_WIDTH-1 : 0] Hwdata;
  rand logic [ADDR_WIDTH-1 : 0] Haddr;
  logic [DATA_WIDTH-1 : 0] Hrdata;
  rand logic [1:0] Htrans;
  rand logic Hwrite;
  rand logic [2:0] Hsize;
  rand logic [2:0] Hburst;
  logic Hresp;
  rand logic [1:0] Hsel;
  logic Hready;
  
 //constraint valid_data {Hwdata >= 0 && Hwdata <= (2**DATA_WIDTH)-1; Hrdata >= 0 && Hrdata <= (2**DATA_WIDTH)-1;}
 //constraint valid_addr {Haddr >= 0 && Haddr <= (2**ADDR_WIDTH)-1;}
 //constraint valid_data_ic{if((Haddr >= 0) && Haddr <= (((2**DATA_WIDTH)/3) - 1)) Hsel == 2'b00;
                          //if((Haddr >= ((2**DATA_WIDTH)/3)) && (Haddr <=  ((((2**DATA_WIDTH)/3)+ ((2**DATA_WIDTH)/3))-1))) Hsel == 2'b01;
                          //if((Haddr >= (((2**DATA_WIDTH)/3)+ ((2**DATA_WIDTH)/3))) && (Haddr <= ((2**DATA_WIDTH)- 1))) Hsel == 2'b10;
                         //} 
 constraint HSelect {Hsel inside {0,1,2};}

  function display(string name);
    $display("Display Function called from %s class", name);
    $display("Time = %0t | Hwdata = 0x%0h | Haddr =  0x%0h | Hrdata = 0x%0h | Htrans = 0x%0h | Hwrite = 0x%0h | Hsize = 0x%0h | Hburst = 0x%0h | Hresp = 0x%0h | Hsel = 0x%0h ", $time,Hwdata,Haddr,Hrdata,Htrans,Hwrite,Hsize,Hburst,Hresp,Hsel);
  endfunction

endclass
