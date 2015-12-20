.PHONY: run clean compile sim

TB_FILES = top_tb.sv

run: compile sim

compile:
	if [ ! -e work ]; then vlib work; fi
	vlog -sv -novopt +incdir+../sv $(TB_FILES)

sim:
	vsim -novopt -c -do do.tcl work.top_tb

clean:
	rm -rf work transcript

