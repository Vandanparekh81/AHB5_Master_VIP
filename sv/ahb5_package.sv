package ahb5_pkg;
  typedef enum logic [1:0] {SANITY_TESTCASE = 2'b00, DIRECTED_TESTCASE = 2'b01, RANDOM_TESTCASE = 2'b10} testcase_t;
  `include "ahb5_configure.sv"
  typedef logic [ADDR_WIDTH-1:0] mem[*];
  `include "ahb5_transaction.sv"
  `include "ahb5_generator.sv"
  `include "ahb5_driver.sv"
  `include "../sve/ahb5_slave_dummy_driver.sv"
  `include "ahb5_monitor.sv"
  `include "ahb5_scoreboard.sv"
  `include "../sv/ahb5_environment.sv"
endpackage
  `include "../sv/ahb5_Interface.sv"
  `include "../sve/ahb5_test.sv"
  `include "../tb_top/ahb5_top.sv"
