//transaction class contains that signals which can be transfered between components  
class AT_ahb5_transaction_c;
  rand int AT_wr_count_i; // Write transaction count
  rand int AT_rd_count_i; // Read transaction count 
  rand logic [DATA_WIDTH-1 : 0] AT_Hwdata_l; // Write data of AHB5  
  rand logic [ADDR_WIDTH-1 : 0] AT_Haddr_l; //  Address of AHB5 
  logic [DATA_WIDTH-1 : 0] AT_Hrdata_l; // Read data of AHB5
  rand logic [1:0] AT_Htrans_l; // Transfer mode of AHB5 00 = IDLE, 01 = BUSY, 10 = NONSEQ, 11 = SEQ 
  logic AT_Hwrite_l; //Write or Read Signal When it is 1 then it indicate write operation and when it is 0 then it indicate Read operation
  rand logic [2:0] AT_Hsize_l; //Size of data transfer BYTE = 3'b000, HALFWORD = 3'b001, WORD = 3'b010, DOUBLEWORD = 3'b011, FOURWORD = 3'b100, EIGHTWORD = 3'b101, SIXTEENWORD = 3'b110, THIRTYTWOWORD = 3'b111
  rand logic [2:0] AT_Hburst_l; // This signal indicate burst transfer SINGLE = 3'b000, INCR = 3'b001, WRAP4 = 3'b010, INCR4 = 3'b011, WRAP8 = 3'b100, INCR8 = 3'b101, WRAP16 = 3'b110, INCR16 = 3'b111
  logic AT_Hresp_l; // This signal indicate response of slave if it is 0 then it indicate OKAY response if it is 1 Then it indicate ERROR Response
  rand logic [1:0] AT_Hsel_l; // This signal decide which slave activate at a time
  logic AT_Hready_l; // This signal indicate slave is ready or not ready for transfer , When it is 1 slave is ready for transfer and it is 0 slave is not ready transfer
  rand int AT_burst_beat_length_i; // This signal depend on Hburst signal when Hburst is single AT_burst_beat_length_i is 1 and when Hburst is INCRthen AT_burst_beat_length_i is undefined length burst and Hbusrt is INCR4 | WRAP4 then AT_burst_beat_length_i is 4 and Hburst is INCR8 | WRAP8 then AT_burst_beat_length_i is 8 and When Hburst is INCR16 | WRAP16 then AT_burst_beat_length_i is 16
  mem AT_Haddr_mem_t; // Dummy Memory , This memory is used for storing address so we can use that same for address in read operation
  testcase_t AT_testcase_te; // this signal indicate which testcase is selected

  
 //constraint valid_data {AT_Hwdata_l >= 0 && AT_Hwdata_l <= (2**DATA_WIDTH)-1; AT_Hrdata_l >= 0 && AT_Hrdata_l <= (2**DATA_WIDTH)-1;}
 //constraint valid_addr {AT_Haddr_l >= 0 && AT_Haddr_l <= (2**ADDR_WIDTH)-1;}
 //constraint valid_data_ic{if((AT_Haddr_l >= 0) && AT_Haddr_l <= (((2**DATA_WIDTH)/3) - 1)) Hsel == 2'b00;
                          //if((AT_Haddr_l >= ((2**DATA_WIDTH)/3)) && (AT_Haddr_l <=  ((((2**DATA_WIDTH)/3)+ ((2**DATA_WIDTH)/3))-1))) Hsel == 2'b01;
                          //if((AT_Haddr_l >= (((2**DATA_WIDTH)/3)+ ((2**DATA_WIDTH)/3))) && (AT_Haddr_l <= ((2**DATA_WIDTH)- 1))) Hsel == 2'b10;
                         //}
  constraint AT_Htrans_state_c{AT_Htrans_l == 2;} // This Constraint written for valid Htrans

  constraint AT_Address_c {AT_Hwrite_l -> !(AT_Haddr_l inside {AT_Haddr_mem_t}); !AT_Hwrite_l -> (AT_Haddr_l inside {AT_Haddr_mem_t}); } // This constraint take unique address for write operation and take that same adress for read operation using dummy memory

  constraint AT_single_Hburst_c {AT_Hburst_l == 0;} // this constraint select only single busrst mode

  constraint AT_HSelect_c {AT_Hsel_l == 0;} // Currently using only one slave so Hsel equal to 0 means only one slave

  constraint AT_burst_beats_length_c {if(AT_Hsize_l  == 3'b000) AT_burst_beat_length_i == 1; if(AT_Hsize_l == 3'b001) AT_burst_beat_length_i inside {[1:16]}; if(AT_Hsize_l == 3'b010 || AT_Hsize_l == 3'b011) AT_burst_beat_length_i == 4; if(AT_Hsize_l == 3'b100 || AT_Hsize_l == 3'b101) AT_burst_beat_length_i == 8; if(AT_Hsize_l == 3'b110 || AT_Hsize_l == 3'b111) AT_burst_beat_length_i == 16;} // This constraint is show that how the value of AT_burst_beat_length_i depend on Hburst

  //This function is written to save unique address into memory which is generated during write operation and it is deleted from memory during read operation  
  function void post_randomize(); //This post_randomize function which called automatically after randomization
    if(AT_Hwrite_l)
      AT_Haddr_mem_t[AT_Haddr_l] = AT_Haddr_l; // This statement indicate that if AT_Hwrite_l is high then we have to store address into memory
    else
      AT_Haddr_mem_t.delete(AT_Haddr_l); //This statement indicate that if AT_Hwrite_l is low then we have to delete the address from memory
  endfunction
          
  /*function new(testcase_t testcase);
          this.testcase = testcase;
  endfunction*/

  // Display task , This reusable task it is called from all components
  task AT_display_t(string name);
    $display("------------------------------------------------------");
    $display("Display Function called from %s class", name);
    $display("Time = %0t | AT_Hwdata_l = 0x%0h | AT_Haddr_l =  0x%0h | AT_Hrdata_l = 0x%0h | AT_Htrans_l = 0x%0h | AT_Hwrite_l = 0x%0h | AT_Hsize_l = 0x%0h | AT_Hburst_l = 0x%0h | AT_Hresp_l = 0x%0h | AT_Hsel_l = 0x%0h | AT_Hready_l = 0x%0h", $time,AT_Hwdata_l,AT_Haddr_l,AT_Hrdata_l,AT_Htrans_l,AT_Hwrite_l,AT_Hsize_l,AT_Hburst_l,AT_Hresp_l,AT_Hsel_l,AT_Hready_l);
    $display("Time = %0t | AT_Haddr_mem_t = %p", $time, AT_Haddr_mem_t);
    $display("-------------------------------------------------------");
  endtask

endclass
