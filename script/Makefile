# Makefile supports compilation, simulation, waveform dump and cleanup and also select testcases via testname and generates logs and organizes outputs as per test and seed

# Path to AHB5 Package file
path += ../sv/ahb5_package.sv

# Simulation directory
SIM_DIR = ../sim/

# Log directories
Log = log/

# Top Module name
TOP_MODULE = AT_ahb5_top_m

# Default testcase if not passed externally
override TEST_NAME ?=0

# Default Value of number of write transactions if not passed externally
override NO_OF_WR ?=1

# Default Value of number of read transactions if not passed externally
override NO_OF_RD ?=1

# Default Value of number of random transactions if not passed externally
override NO_OF_RANDOM ?=5

# Work directory
WORK += ../script/work

# Default Waveform not dumping if you not passed WAVES = 1
override WAVES ?=0

# If WAVES = 1 then include waveform files for moving purpose
ifeq ($(WAVES),1)
	wlf += ../script/*.wlf
endif

# Seed for randomization
override SEED ?=100 

# Testcase selection based on TEST_NAME Variable
ifeq ($(TEST_NAME),0)
	DIRECTORY = SANITY_TESTCASE
endif
ifeq ($(TEST_NAME),1)
	DIRECTORY = DIRECTED_TESTCASE
endif
ifeq ($(TEST_NAME),2)
	DIRECTORY = RANDOM_TESTCASE
endif

# Default target
all:compile sim move

# Only compile and simulate
compile_with_vsim:compile sim

# compile AHB5_package using vlog 
compile:
	@echo "compiling...."
	@vlog $(path)

# Simulation flow 
sim:
	@vopt work.$(TOP_MODULE) -o tb_opt +acc=arn
ifeq ($(WAVES),1)
        # Create directories for log and waveform
	mkdir -p $(SIM_DIR)$(Log)$(DIRECTORY)_$(SEED)
	# Run with GUI Wave capture
	vsim -c -assertdebug -msgmode both work.tb_opt +STRING=$(TEST_NAME) +NO_OF_WRITE=$(NO_OF_WR) +NO_OF_READ=$(NO_OF_RD) +NO_OF_RANDOM=$(NO_OF_RANDOM) -sv_seed $(SEED) -l $(SIM_DIR)$(Log)$(DIRECTORY)_$(SEED)/$(DIRECTORY)_$(SEED).log -do "add wave -r /*; run -all"
else
        # Create directories for log and waveform
	mkdir -p $(SIM_DIR)$(Log)$(DIRECTORY)_$(SEED)
	# Run without GUI Wave capture
	vsim -c -assertdebug work.tb_opt +STRING=$(TEST_NAME) +NO_OF_WRITE=$(NO_OF_WR) +NO_OF_READ=$(NO_OF_RD) +NO_OF_RANDOM=$(NO_OF_RANDOM) -sv_seed $(SEED) -l $(SIM_DIR)$(Log)$(DIRECTORY)_$(SEED)/$(DIRECTORY)_$(SEED).log -do "run -all"
endif

# Move wavefiles to appropriate folder
move:  
ifeq ($(WAVES),1)
	@mv $(wlf) $(SIM_DIR)/$(Log)/$(DIRECTORY)_$(SEED)/$(DIRECTORY)_$(SEED).wlf
endif

# Clean Work Directoey
clean:
	@rm -rf $(WORK)
