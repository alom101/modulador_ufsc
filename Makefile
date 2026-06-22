# ==============================================================================
# GHDL ORDERED MULTI-FILE MAKEFILE
# ==============================================================================

# 1. Design Configuration
# Set this to the base name of your testbench entity (without _testbench)
TOP_MODULE = lut

# 2. Automatically Find and Separate VHDL Files
ALL_SOURCES := $(wildcard *.vhd)

# Separate testbenches from core entity files based on your naming convention
TB_SOURCES  := $(filter %_testbench.vhd, $(ALL_SOURCES))
CORE_SOURCES:= $(filter-out %_testbench.vhd, $(ALL_SOURCES))

# 3. File and Tool Configurations
TB_ENTITY = $(TOP_MODULE)_testbench
VCD_FILE  = $(TOP_MODULE)_testbench.vcd

GHDL      = ghdl
WAVE_VIEW = gtkwave
FLAGS     = --std=08 # Adjust to --std=93 or --std=02 depending on your VHDL version

# ==============================================================================
# Targets
# ==============================================================================

.PHONY: all analyze_core analyze_tb analyze elaborate run view clean

# Default target
all: run

# Step 1a: Analyze core design files first
analyze_core: $(CORE_SOURCES)
	@echo "Analyzing core entities: $(CORE_SOURCES)"
	$(GHDL) -a $(FLAGS) $(CORE_SOURCES)

# Step 1b: Analyze testbenches only after core entities are safely in the 'work' library
analyze_tb: analyze_core $(TB_SOURCES)
	@echo "Analyzing testbenches: $(TB_SOURCES)"
	$(GHDL) -a $(FLAGS) $(TB_SOURCES)

# Unified analyze target for dependency chaining
analyze: analyze_tb

# Step 2: Elaborate the specific testbench entity
elaborate: analyze
	$(GHDL) -e $(FLAGS) $(TB_ENTITY)

# Step 3: Run the simulation and dump the VCD file
run: elaborate
	$(GHDL) -r $(FLAGS) $(TB_ENTITY) --vcd=$(VCD_FILE)

# Step 4: Open the results in GTKWave
view: run
	$(WAVE_VIEW) $(VCD_FILE)

# Clean up generated simulation framework files
clean:
	$(GHDL) --clean
	rm -f *.o *.cf $(TB_ENTITY) $(VCD_FILE)
