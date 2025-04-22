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
  rand int burst_beat_length;

  
 //constraint valid_data {Hwdata >= 0 && Hwdata <= (2**DATA_WIDTH)-1; Hrdata >= 0 && Hrdata <= (2**DATA_WIDTH)-1;}
 //constraint valid_addr {Haddr >= 0 && Haddr <= (2**ADDR_WIDTH)-1;}
 //constraint valid_data_ic{if((Haddr >= 0) && Haddr <= (((2**DATA_WIDTH)/3) - 1)) Hsel == 2'b00;
                          //if((Haddr >= ((2**DATA_WIDTH)/3)) && (Haddr <=  ((((2**DATA_WIDTH)/3)+ ((2**DATA_WIDTH)/3))-1))) Hsel == 2'b01;
                          //if((Haddr >= (((2**DATA_WIDTH)/3)+ ((2**DATA_WIDTH)/3))) && (Haddr <= ((2**DATA_WIDTH)- 1))) Hsel == 2'b10;
                         //} 
 constraint HSelect {Hsel inside {0,1,2};}
 constraint burst_beats_length {if(Hsize  == 3'b000) burst_beat_length == 1; if(Hsize == 3'b001) burst_beat_length inside {[1:16]}; if(Hsize == 3'b010 || Hsize == 3'b011) burst_beat_length == 4; if(Hsize == 3'b100 || Hsize == 3'b101) burst_beat_length == 8; if(Hsize == 3'b110 || Hsize == 3'b111) burst_beat_length == 16;}

  function display(string name);
    $display("Display Function called from %s class", name);
    $display("Time = %0t | Hwdata = 0x%0h | Haddr =  0x%0h | Hrdata = 0x%0h | Htrans = 0x%0h | Hwrite = 0x%0h | Hsize = 0x%0h | Hburst = 0x%0h | Hresp = 0x%0h | Hsel = 0x%0h | Hready = 0x%0h", $time,Hwdata,Haddr,Hrdata,Htrans,Hwrite,Hsize,Hburst,Hresp,Hsel,Hready);
  endfunction

endclass
