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
#log += ../script/*.vcd
log += ../script/transcript
#log +=*vstf
log += ../script/*.wlf
log += ../script/work
#log += ../script/.log
override WAVES ?=0
override SEED ?=100 

all:compile sim wave move
compile_with_vsim:compile sim
	
compile:
	@echo "compiling...."
	#+STRING=DIRECTED_TESTCASE
	@vlog $(path)
sim:
	#+STRING=DIRECTED_TESTCASE
	@vopt work.ahb5_top -o tb_opt +acc=arn
	#@vsim -c  -assertdebug work.tb_opt -l ahb_m.log -do "add wave -r /*; run -all"
	#@mv -f $(log) ../sim/
wave:
ifeq ($(WAVES),1)
	#+STRING=DIRECTED_TESTCASE
	vsim -c -assertdebug work.tb_opt -sv_seed $(SEED) -l $(SIM_DIR)/ahb_m.log -do "add wave -r /*; run -all"
	vsim vsim.wlf -do "add wave -r /*"
else
	#+STRING=DIRECTED_TESTCASE
	vsim -c -assertdebug work.tb_opt -sv_seed $(SEED) -do "run -all"
endif

move:  
	@rm -rf $(SIM_DIR)/work
	@mv $(log) $(SIM_DIR)
clean:
	@rm -rf $(log) ../sim/
