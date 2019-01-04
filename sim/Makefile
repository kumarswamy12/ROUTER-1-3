#Makefile for UVM Testbench
RTL = ../rtl/*
INC = +incdir+../wr_agt_top +incdir+../rd_agt_top +incdir+../test +incdir+../tb +incdir+../src 
SVTB =  ../tb/router_top_tb.sv
SVTB1 = ../test/router_pkg.sv
COVOP= -dbg -coverage sba
work = work
VSIMOPT= +access +r -sva 
VSIMBATCH = -acdb_file mem_cov.acdb
VSIMBATCH1 = -c -acdb_file mem_cov1.acdb -do "log -rec *;run -all;exit"
VSIMBATCH2 = -c -acdb_file mem_cov2.acdb -do "log -rec *;;run -all;exit"
VSIMBATCH3 = -c -acdb_file mem_cov3.acdb -do "log -rec *;;run -all;exit"
VSIMBATCH4 = -c -acdb_file mem_cov4.acdb -do "log -rec *;;run -all;exit"

lib:
	vlib $(work)
	vmap work $(work)

sv_cmp:clean  lib comp0

run_sim:
	vsim $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH1) -sv_seed random -l s.log work.top   +UVM_TESTNAME=ram_ten_addr_test 
	vsim -c -do "acdb report -db mem_cov1.acdb -html -o mem_cov1.html" 
gui:
	vsim& 	

comp0:
	vlog -uvm -work $(work) $(COVOP) $(RTL) $(INC) $(SVTB1) $(SVTB)

run_test: sv_cmp
	vsim  $(VSIMBATCH1) $(VSIMOPT) $(VSIMCOV)  -sva -sv_seed random -l test1_sim.log work.top +UVM_OBJECTION_TRACE +UVM_TESTNAME=router_test_c1 +UVM_VERBOSITY=UVM_MEDIUM #The Default Verbosity is medium
	vsim -c -do "acdb report -db mem_cov1.acdb -html -o mem_cov1.html;exit"   

run_test1:sv_cmp
	vsim  $(VSIMBATCH2) $(VSIMOPT) $(VSIMCOV)  -sva -sv_seed random -l test2_sim.log work.top +UVM_OBJECTION_TRACE +UVM_TESTNAME=ram_ten_addr_test +UVM_VERBOSITY=UVM_MEDIUM #The Default Verbosity is medium
	vsim -c -do "acdb report -db mem_cov1.acdb -html -o mem_cov2.html;exit" 

run_test2:
	vsim  $(VSIMBATCH3) $(VSIMOPT) $(VSIMCOV)  -sva -sv_seed random -l test3_sim.log work.top +UVM_OBJECTION_TRACE +UVM_TESTNAME=ram_odd_addr_test +UVM_VERBOSITY=UVM_MEDIUM #The Default Verbosity is medium
	vsim -c -do "acdb report -db mem_cov2.acdb -html -o mem_cov3.html;exit" 

run_test3:
	vsim  $(VSIMBATCH4) $(VSIMOPT) $(VSIMCOV)  -sva -sv_seed random -l test4_sim.log work.top +UVM_OBJECTION_TRACE +UVM_TESTNAME=ram_even_addr_test +UVM_VERBOSITY=UVM_MEDIUM #The Default Verbosity is medium
	vsim -c -do "acdb report -db mem_cov3.acdb -html -o mem_cov4.html;exit" 

clean:
	rm -rf modelsim.* transcript* *log* work vsim.wlf fcover* covhtml* mem_cov*
	clear
report:
	vsim -c -do "acdb merge -cov sbfa -i mem_cov1.acdb -i mem_cov2.acdb -i mem_cov3.acdb -o mem_cov_merged.acdb;exit"

rep:
	vsim -c -do "acdb report -db mem_cov_merged.acdb -html -o mem_cov_merged.html;exit" 

regress: clean run_test run_test1 run_test2 run_test3 report rep cov

cov:
	firefox mem_cov_merged.html&
