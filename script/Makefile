#path += ../tb_top/ahb5_top.sv
path += ../sv/ahb5_package.sv
#path += ../sv/ahb5_transaction.sv
#path += ../sv/ahb5_Interface.sv
#path += ../sv/ahb5_environment.sv
#path += ../sve/ahb5_test.sv
#path += ../sv/ahb5_monitor.sv
#path += ../sv/ahb5_scoreboard.sv
#path += ../sv/ahb5_generator.sv
#path += ../sv/ahb5_driver.sv
SIM_DIR = ../sim/
LOG = log
Log = ./log/
override TEST_NAME ?=0
#log += ../script/*.vcd
#log +=*vstf

WORK += ../script/work
#log += ../script/.log
override WAVES ?=0

ifeq ($(WAVES),1)
	wlf += ../script/*.wlf
endif
override SEED ?=100 
ifeq ($(TEST_NAME),0)
	DIRECTORY = SANITY_TESTCASE
endif
ifeq ($(TEST_NAME),1)
	DIRECTORY = DIRECTED_TESTCASE
endif
ifeq ($(TEST_NAME),2)
	DIRECTORY = RANDOM_TESTCASE
endif
all:compile sim move
compile_with_vsim:compile sim
	
compile:
	@echo "compiling...."
	@vlog $(path)
sim:
	@vopt work.ahb5_top -o tb_opt +acc=arn
	#@vsim -c  -assertdebug work.tb_opt -l ahb_m.log -do "add wave -r /*; run -all"
	#@mv -f $(log) ../sim/
ifeq ($(WAVES),1)
	#vsim -c -assertdebug work.tb_opt -sv_seed $(SEED) -l $(SIM_DIR)/test_name_$(SEED).log -do "add wave -r /*; run -all"
	mkdir -p $(SIM_DIR)$(LOG)
	mkdir -p $(SIM_DIR)$(Log)$(DIRECTORY)_$(SEED)
	vsim -c -assertdebug work.tb_opt +STRING=$(TEST_NAME) -sv_seed $(SEED) -l $(SIM_DIR)/$(Log)/$(DIRECTORY)_$(SEED)/$(DIRECTORY)_$(SEED).log -do "add wave -r /*; run -all"
else
	mkdir -p $(SIM_DIR)$(LOG)
	mkdir -p $(SIM_DIR)$(Log)$(DIRECTORY)_$(SEED)
	vsim -c -assertdebug work.tb_opt +STRING=$(TEST_NAME) -sv_seed $(SEED) -l $(SIM_DIR)/$(Log)/$(DIRECTORY)_$(SEED)/$(DIRECTORY)_$(SEED).log -do "run -all"
endif

move:  
	#@rm -rf $(SIM_DIR)/work
ifeq ($(WAVES),1)
	@mv $(wlf) $(SIM_DIR)/$(Log)/$(DIRECTORY)_$(SEED)/$(DIRECTORY)_$(SEED).wlf
endif
clean:
	@rm -rf $(WORK)
	
