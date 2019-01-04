interface router_if(input bit clk);

logic [7:0 ]data_in;
logic pkt_valid;
logic resetn;
logic err,busy;
logic read_enb;
logic [7:0] data_out;
logic vld_out;

clocking w_dr_cb@(posedge clk);
default input#1 output  #1;
	input busy;
	output pkt_valid;
	output  data_in;
	output resetn;
endclocking

clocking w_mon_cb@(posedge clk);
default input#1 output  #1;
	input pkt_valid;
	input  data_in;
	input resetn;
	input busy;
endclocking

clocking r_mon_cb@(posedge clk);
default input#1 output  #1;
	input  data_out;
	input read_enb;
endclocking

clocking r_dr_cb@(posedge clk);
default input#1 output  #1;
	input vld_out;
	output read_enb;
endclocking

modport W_DR_MP(clocking w_dr_cb);
modport W_MON_MP(clocking w_mon_cb);
modport R_MON_MP(clocking r_mon_cb);
modport R_DR_MP(clocking r_dr_cb);

endinterface

	 
