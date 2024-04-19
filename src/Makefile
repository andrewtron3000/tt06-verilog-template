V_DIRS = -vdir verilog_dir -bdir build_v -info-dir build_v
BSC_COMP_FLAGS = -elab -keep-fires -aggressive-conditions -no-warn-action-shadowing -remove-unused-modules -verilog-filter ./verilog_filter.py
BSC_PATHS = -p src_BSV:%/Libraries:%/../../../bsc-contrib/Libraries/FPGA/Misc

TOPMODULE ?= mkRule30Driver
TOPFILE   ?= src_BSV/Rule30Driver.bsv

verilog: build_v verilog_dir
	bsc -u -verilog $(V_DIRS) $(BSC_COMP_FLAGS) $(BSC_PATHS) -g $(TOPMODULE)  $(TOPFILE)
	cp verilog_dir/mkRule30.v .
	cp verilog_dir/mkRule30Driver.v .

build_v:
	mkdir  build_v

verilog_dir:
	mkdir  verilog_dir

clean:
	rm -rf build_b verilog_dir
	rm -f mkRule30.v mkRule30Driver.v