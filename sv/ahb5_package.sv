package ahb5_pkg;
  typedef enum logic [1:0] {WRITE_TEST = 2'b00, READ_TEST = 2'b01, RANDOM_TEST = 2'b10} testcase_t;
  `include "ahb5_configure.sv"
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
