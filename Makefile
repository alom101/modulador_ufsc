# ==============================================================================
# GHDL ORDERED MULTI-FILE MAKEFILE
# ==============================================================================

# Set this to the base name of your testbench entity (without _testbench)
TOP_MODULE = modulator


# File lists
ALL_SOURCES := $(wildcard *.vhd)

TB_SOURCES  := $(filter %_testbench.vhd, $(ALL_SOURCES))
CORE_SOURCES:= $(filter-out %_testbench.vhd, $(ALL_SOURCES))

TB_ENTITIES = $(patsubst %.vhd,%,$(TB_SOURCES))

TB_ENTITY = $(TOP_MODULE)_testbench
VCD_FILE  = $(TOP_MODULE)_testbench.vcd

GHDL      = ghdl
WAVE_VIEW = gtkwave
FLAGS     = --std=08 # Adjust to --std=93 or --std=02 depending on your VHDL version

# ==============================================================================
# Targets
# ==============================================================================


# Default target
all: view_toplevel

analyze_core: $(CORE_SOURCES)
	@echo "--------------------------------------------"
	@echo "Analyzing core entities: $(CORE_SOURCES)"
	$(GHDL) -a $(FLAGS) $(CORE_SOURCES)

analyze_tb: analyze_core $(TB_SOURCES)
	@echo "--------------------------------------------"
	@echo "Analyzing testbenches: $(TB_SOURCES)"
	$(GHDL) -a $(FLAGS) $(TB_SOURCES)

elaborate: analyze_tb
	@echo "--------------------------------------------"
	@echo "Starting elaboration..."
	@for tb in $(TB_ENTITIES); do \
		echo "Elaborating testbench entity: $$tb"; \
		$(GHDL) -e $(FLAGS) $$tb; \
	done

run: elaborate
	@echo "--------------------------------------------"
	@echo "Starting simulation..."
	@for tb in $(TB_ENTITIES); do \
		echo "Simulating testbench entity: $$tb"; \
		$(GHDL) -r $(FLAGS) $$tb --vcd=$$tb.vcd; \
	done

view_toplevel: run
	@echo "--------------------------------------------"
	@echo "Viewing toplevel vcd file"
	$(WAVE_VIEW) $(VCD_FILE)

view_all: run
	@echo "--------------------------------------------"
	@echo "Viewing all vcd files"
	@for tb in $(TB_ENTITIES); do \
		$(WAVE_VIEW) $$tb.vcd & \
	done

clean:
	$(GHDL) --clean
	rm -f *.o *.cf *_testbench *.vcd
