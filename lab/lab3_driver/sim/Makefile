.PHONY: run clean compile sim

TB_DIR = ../tb
PKT_DIR = ../sv

TB_TOP = $(TB_DIR)/tb_top.sv
HW_TOP = $(TB_DIR)/hw_top.sv

COMP_FILES := $(HW_TOP) $(TB_TOP)

run: compile sim

compile:
	if [ ! -e work ]; then vlib work; fi
	vlog -sv -novopt +incdir+$(PKT_DIR) $(COMP_FILES)

sim:
	vsim -novopt -c -do do.tcl -wlf wave.wlf -l simv.log work.tb_top work.hw_top

clean:
	rm -rf work transcript wave.wlf simv.log

