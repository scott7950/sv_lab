.PHONY: run clean compile sim

TB_TOP = tb_top.sv
HW_TOP = hw_top.sv

COMP_FILES := $(HW_TOP) $(TB_TOP)

run: compile sim

compile:
	if [ ! -e work ]; then vlib work; fi
	vlog -sv -novopt +incdir+../sv $(COMP_FILES)

sim:
	vsim -novopt -c -do do.tcl work.tb_top work.hw_top

clean:
	rm -rf work transcript

