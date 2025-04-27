import ahb5_pkg::*;
class ahb5_transaction;
   //typedef enum logic [1:0] {IDLE = 2'b00, BUSY = 2'b01, NONSEQ = 2'b10, SEQ = 2'b11} htrans_t; 
   //typedef enum logic [2:0] {SINGLE = 3'b000, INCR = 3'b001, WRAP4 = 3'b010, INCR4 = 3'b011, WRAP8 = 3'b100, INCR8 = 3'b101, WRAP16 = 3'b110, INCR16 = 3'b111} hburst_t;                          
   //typedef enum logic [2:0] {BYTE = 3'b000, HALFWORD = 3'b001, WORD = 3'b010, DOUBLEWORD = 3'b011, FOURWORD = 3'b100, EIGHTWORD = 3'b101, SIXTEENWORD = 3'b110, THIRTYTWOWORD = 3'b111} hsize_t; 
  rand int wr_count;
  rand int rd_count;
  rand logic [DATA_WIDTH-1 : 0] Hwdata;
  rand logic [ADDR_WIDTH-1 : 0] Haddr;
  logic [DATA_WIDTH-1 : 0] Hrdata;
  rand logic [1:0] Htrans;
  logic Hwrite;
  rand logic [2:0] Hsize;
  rand logic [2:0] Hburst;
  logic Hresp;
  rand logic [1:0] Hsel;
  logic Hready;
  rand int burst_beat_length;
  mem Haddr_mem;
  testcase_t testcase;

  
 //constraint valid_data {Hwdata >= 0 && Hwdata <= (2**DATA_WIDTH)-1; Hrdata >= 0 && Hrdata <= (2**DATA_WIDTH)-1;}
 //constraint valid_addr {Haddr >= 0 && Haddr <= (2**ADDR_WIDTH)-1;}
 //constraint valid_data_ic{if((Haddr >= 0) && Haddr <= (((2**DATA_WIDTH)/3) - 1)) Hsel == 2'b00;
                          //if((Haddr >= ((2**DATA_WIDTH)/3)) && (Haddr <=  ((((2**DATA_WIDTH)/3)+ ((2**DATA_WIDTH)/3))-1))) Hsel == 2'b01;
                          //if((Haddr >= (((2**DATA_WIDTH)/3)+ ((2**DATA_WIDTH)/3))) && (Haddr <= ((2**DATA_WIDTH)- 1))) Hsel == 2'b10;
                         //}
  //constraint HWrite {if(testcase == WRITE_TEST) Hwrite == 1; if(testcase == READ_TEST) Hwrite == 0; }
  constraint Address {Hwrite -> !(Haddr inside {Haddr_mem}); !Hwrite -> (Haddr inside {Haddr_mem}); }

  constraint HSelect {Hsel inside {0,1,2};}
  constraint burst_beats_length {if(Hsize  == 3'b000) burst_beat_length == 1; if(Hsize == 3'b001) burst_beat_length inside {[1:16]}; if(Hsize == 3'b010 || Hsize == 3'b011) burst_beat_length == 4; if(Hsize == 3'b100 || Hsize == 3'b101) burst_beat_length == 8; if(Hsize == 3'b110 || Hsize == 3'b111) burst_beat_length == 16;}
  function void post_randomize();
    if(Hwrite)
      Haddr_mem[Haddr] = Haddr;
    else
      Haddr_mem.delete(Haddr);
  endfunction
          
  /*function new(testcase_t testcase);
          this.testcase = testcase;
  endfunction*/
  function display(string name);
    $display("------------------------------------------------------");
    $display("Display Function called from %s class", name);
    $display("Display the bits of Hwdata = %0d and size of Hwdata = %0d", $bits(Hwdata), $size(Hwdata));
    $display("Time = %0t | Hwdata = 0x%0h | Haddr =  0x%0h | Hrdata = 0x%0h | Htrans = 0x%0h | Hwrite = 0x%0h | Hsize = 0x%0h | Hburst = 0x%0h | Hresp = 0x%0h | Hsel = 0x%0h | Hready = 0x%0h", $time,Hwdata,Haddr,Hrdata,Htrans,Hwrite,Hsize,Hburst,Hresp,Hsel,Hready);
    $display("Time = %0t | Haddr_mem = %p", $time, Haddr_mem);
    $display("-------------------------------------------------------");
  endfunction

endclass
