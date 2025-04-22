path += ../tb_top/ahb5_top.sv
#path += ../sv/ahb5_transaction.sv
#path += ../sv/ahb5_Interface.sv
#path += ../sv/ahb5_environment.sv
#path += ../sve/ahb5_test.sv
#path += ../sv/ahb5_monitor.sv
#path += ../sv/ahb5_scoreboard.sv
#path += ../sv/ahb5_generator.sv
#path += ../sv/ahb5_driver.sv
log += ../script/*vcd
log += ../script/transcript
#log +=*vstf
log += ../script/*wlf
log += ../script/work
log += ../script/*log
	
all:compile sim wave
compile_with_vsim:compile sim
	
compile:
	@echo "compiling...."
	@vlog $(path)
sim:
	@vopt work.ahb5_top -o tb_opt +acc=arn
	@vsim -c  -assertdebug work.tb_opt -l ahb_m.log -do "add wave -r /*; run -all"
	#@mv $(log) ../sim/
wave: 
	@vsim vsim.wlf -do "add wave -r /*"

#run:  
	#@run -all
clean:
	@rm -rf work
	#@rm -rf $(log) ../sim/
